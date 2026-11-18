#include "smartmix/BeatThisSpectrogram.hpp"

#include <cstddef>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <vector>

int main(int argc, char **argv) {
    if (argc != 4) {
        std::cerr << "usage: spectrogram_cli input.f32 sample_count output.f32\n";
        return 2;
    }
    const std::size_t sampleCount = static_cast<std::size_t>(std::strtoull(argv[2], nullptr, 10));
    if (!sampleCount) return 2;

    std::vector<float> input(sampleCount);
    std::ifstream inputFile(argv[1], std::ios::binary);
    if (!inputFile.read(reinterpret_cast<char *>(input.data()),
                        static_cast<std::streamsize>(input.size() * sizeof(float)))) {
        std::cerr << "could not read input PCM\n";
        return 3;
    }

    const std::size_t frames = smartmix::beatThisSpectrogramFrameCount(sampleCount);
    std::vector<float> output(frames * smartmix::kBeatThisMelBins);
    if (!smartmix::computeBeatThisSpectrogram(input.data(), sampleCount,
                                               output.data(), frames)) {
        std::cerr << "spectrogram preprocessing failed\n";
        return 4;
    }

    std::ofstream outputFile(argv[3], std::ios::binary);
    if (!outputFile.write(reinterpret_cast<const char *>(output.data()),
                          static_cast<std::streamsize>(output.size() * sizeof(float)))) {
        std::cerr << "could not write spectrogram\n";
        return 5;
    }
    std::cout << frames << " " << smartmix::kBeatThisMelBins << "\n";
    return 0;
}
