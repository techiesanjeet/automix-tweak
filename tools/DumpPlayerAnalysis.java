// Ghidra post-analysis script: follow xrefs to Spotify player/mixing metadata
// and decompile the code functions that consume it. Static analysis only.
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

        Map<String, Function> callers = new LinkedHashMap<>();
        int matchingData = 0;
        int totalXrefs = 0;
        try (PrintWriter out = new PrintWriter(output, "UTF-8")) {
            out.println("Spotify player/mixing xref analysis (static only)");
            out.println("Program: " + currentProgram.getName());
            out.println("Image base: " + currentProgram.getImageBase());
            out.println();

            // Keep this pass bounded: Ghidra's full-binary decompiler repeatedly
            // stalled on cross-image references in the prior run. Direct data
            // xrefs identify the functions that deserve a later narrow review.
            for (Data data : currentProgram.getListing().getDefinedData(true)) {
                if (monitor.isCancelled() || matchingData >= 80) break;
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
                int refsForData = 0;
                while (refs.hasNext()) {
                    if (monitor.isCancelled() || refsForData >= 32 || totalXrefs >= 500) break;
                    Reference ref = refs.next();
                    Function function = currentProgram.getFunctionManager()
                        .getFunctionContaining(ref.getFromAddress());
                    out.println("  XREF " + ref.getFromAddress() + " type="
                        + ref.getReferenceType() + " function="
                        + (function == null ? "<none>" : function.getName()
                            + " @ " + function.getEntryPoint()));
                    if (function != null && callers.size() < 200) {
                        callers.put(function.getEntryPoint().toString(), function);
                    }
                    refsForData++;
                    totalXrefs++;
                }
                out.flush();
            }

            out.println();
            out.println("Matching data entries: " + matchingData);
            out.println("Total direct xrefs recorded: " + totalXrefs);
            out.println("Unique referencing functions: " + callers.size());
            out.println("\n===== CALLER INDEX (entry point and Ghidra name only) =====");
            for (Function function : callers.values()) {
                out.println(function.getEntryPoint() + "  " + function.getName());
            }
            out.println("\nNo functions were decompiled in this bounded pass.");
            out.flush();
        }
        println("Wrote " + output.getAbsolutePath());
    }
}

