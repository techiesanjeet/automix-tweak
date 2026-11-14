// Ghidra post-analysis script: follow xrefs to Spotify player/mixing metadata
// and decompile the code functions that consume it. Static analysis only.
import ghidra.app.decompiler.DecompInterface;
import ghidra.app.decompiler.DecompileResults;
import ghidra.app.script.GhidraScript;
import ghidra.program.model.data.Data;
import ghidra.program.model.listing.Function;
import ghidra.program.model.symbol.Reference;
import ghidra.program.model.symbol.ReferenceIterator;
import java.io.File;
import java.io.PrintWriter;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

public class DumpPlayerAnalysis extends GhidraScript {
    private static final String[] TERMS = {
        "playerPool", "internalPlayerFactory", "playbackRequestFactory",
        "audioCoordinator", "hasStartedPlayback", "unmutedHandleProvider",
        "playingTransitionContext", "MixingTransitionPlayer",
        "MixingCoreAutomix", "playerLimit", "MultiPlayer_PlayerImpl",
        "InternalPlayerImpl", "InternalAudioCoordinator"
    };

    @Override
    protected void run() throws Exception {
        String workspace = System.getenv("GITHUB_WORKSPACE");
        if (workspace == null || workspace.isEmpty()) {
            throw new IllegalStateException("GITHUB_WORKSPACE is not set");
        }
        File output = new File(workspace, "analysis-output/ghidra-player-xrefs.txt");
        output.getParentFile().mkdirs();

        Map<String, Function> candidates = new LinkedHashMap<>();
        int matchingData = 0;
        try (PrintWriter out = new PrintWriter(output, "UTF-8")) {
            out.println("Spotify player/mixing xref analysis (static only)");
            out.println("Program: " + currentProgram.getName());
            out.println("Image base: " + currentProgram.getImageBase());
            out.println();

            for (Data data : currentProgram.getListing().getDefinedData(true)) {
                Object value = data.getValue();
                if (value == null) continue;
                String text = value.toString();
                if (text.length() > 2048) continue;
                String lower = text.toLowerCase(Locale.ROOT);
                boolean match = false;
                for (String term : TERMS) {
                    if (lower.contains(term.toLowerCase(Locale.ROOT))) {
                        match = true;
                        break;
                    }
                }
                if (!match) continue;
                matchingData++;
                out.println("DATA " + data.getAddress() + " " + text.replace('\n', ' '));
                ReferenceIterator refs = currentProgram.getReferenceManager()
                    .getReferencesTo(data.getAddress());
                while (refs.hasNext()) {
                    Reference ref = refs.next();
                    Function function = currentProgram.getFunctionManager()
                        .getFunctionContaining(ref.getFromAddress());
                    out.println("  XREF " + ref.getFromAddress() + " type="
                        + ref.getReferenceType() + " function="
                        + (function == null ? "<none>" : function.getName()
                            + " @ " + function.getEntryPoint()));
                    if (function != null && candidates.size() < 300) {
                        candidates.put(function.getEntryPoint().toString(), function);
                    }
                }
            }

            out.println();
            out.println("Matching data entries: " + matchingData);
            out.println("Unique referencing functions: " + candidates.size());
            out.println("\n===== REFERENCING FUNCTION DECOMPILATIONS =====");
            DecompInterface decompiler = new DecompInterface();
            decompiler.openProgram(currentProgram);
            try {
                int emitted = 0;
                for (Function function : candidates.values()) {
                    if (monitor.isCancelled() || emitted >= 300) break;
                    out.println("\n===== FUNCTION " + function.getName() + " @ "
                        + function.getEntryPoint() + " =====");
                    out.println("signature: " + function.getSignature());
                    DecompileResults result = decompiler.decompileFunction(
                        function, 45, monitor);
                    if (result != null && result.decompileCompleted()
                            && result.getDecompiledFunction() != null) {
                        out.println(result.getDecompiledFunction().getC());
                    } else {
                        out.println("DECOMPILATION FAILED: "
                            + (result == null ? "no result" : result.getErrorMessage()));
                    }
                    emitted++;
                }
            } finally {
                decompiler.dispose();
            }
        }
        println("Wrote " + output.getAbsolutePath());
    }
}
