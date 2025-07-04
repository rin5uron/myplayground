import Foundation
import SwiftWhisper
import AVFoundation

public class LocalWhisperClient {
    private var whisper: Whisper?
    private let modelName = "ggml-base.en" // You might want to make this configurable or detect available models

    public init() {
        loadModel()
    }

    private func loadModel() {
        let executablePath = Bundle.main.executableURL?.deletingLastPathComponent().path ?? FileManager.default.currentDirectoryPath
        let modelPath = (executablePath as NSString).appendingPathComponent("\(modelName).bin")
        let modelURL = URL(fileURLWithPath: modelPath)

        print("DEBUG: Attempting to load Whisper model from: \(modelPath)")

        guard FileManager.default.fileExists(atPath: modelPath) else {
            print("Error: Whisper model \(modelName).bin not found at \(modelPath).")
            return
        }
        self.whisper = Whisper(fromFileURL: modelURL)
        print("DEBUG: Whisper model loaded successfully.")
    }

    public func transcribe(audioData: Data) async throws -> String {
        guard let whisper = self.whisper else {
            print("ERROR: Whisper model not loaded when transcribe was called.")
            throw LocalWhisperError.modelNotLoaded
        }

        print("DEBUG: Transcribe called with audioData size: \(audioData.count) bytes")

        // Convert Data to AVAudioFile
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".wav")
        do {
            try audioData.write(to: tempURL)
            print("DEBUG: Audio data written to temporary file: \(tempURL.lastPathComponent)")
        } catch {
            print("ERROR: Failed to write audio data to temporary file: \(error.localizedDescription)")
            throw LocalWhisperError.audioConversionFailed("Failed to write audio data to temporary file: \(error.localizedDescription)")
        }

        let audioFile: AVAudioFile
        do {
            audioFile = try AVAudioFile(forReading: tempURL)
            print("DEBUG: AVAudioFile created successfully.")
        } catch {
            print("ERROR: Failed to create AVAudioFile from temporary URL: \(error.localizedDescription)")
            throw LocalWhisperError.audioConversionFailed("Failed to create AVAudioFile from temporary URL: \(error.localizedDescription)")
        }

        // Define the target format for Whisper: 16kHz, mono, Float32 PCM
        guard let targetFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 16000, channels: 1, interleaved: false) else {
            print("ERROR: Failed to create target audio format.")
            throw LocalWhisperError.audioConversionFailed("Failed to create target audio format.")
        }
        print("DEBUG: Target audio format defined.")

        let audioBuffer: AVAudioPCMBuffer

        if audioFile.processingFormat.isEqual(to: targetFormat) {
            // If already in target format, just read it
            audioBuffer = AVAudioPCMBuffer(pcmFormat: targetFormat, frameCapacity: AVAudioFrameCount(audioFile.length))!
            try audioFile.read(into: audioBuffer)
            print("DEBUG: Audio read directly into target format buffer.")
        } else {
            // Convert to target format
            guard let converter = AVAudioConverter(from: audioFile.processingFormat, to: targetFormat) else {
                print("ERROR: Failed to create audio converter.")
                throw LocalWhisperError.audioConversionFailed("Failed to create audio converter.")
            }
            print("DEBUG: Audio converter created.")

            // Calculate the output frame capacity
            let frameCapacity = AVAudioFrameCount(Double(audioFile.length) * (targetFormat.sampleRate / audioFile.processingFormat.sampleRate))
            audioBuffer = AVAudioPCMBuffer(pcmFormat: targetFormat, frameCapacity: frameCapacity)!

            // Perform the conversion
            var error: NSError?
            let success = converter.convert(to: audioBuffer, error: &error) { inNumPackets, outStatus in
                let inputBuffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: inNumPackets)!
                do {
                    try audioFile.read(into: inputBuffer, frameCount: inNumPackets)
                    outStatus.pointee = .haveData
                    return inputBuffer
                } catch {
                    print("ERROR: Failed to read audio for conversion: \(error.localizedDescription)")
                    outStatus.pointee = .noDataNow
                    return nil
                }
            }

            if success != .haveData {
                let errorMessage = error?.localizedDescription ?? "Unknown error"
                print("ERROR: Audio conversion failed with status \(success.rawValue): \(errorMessage)")
                throw LocalWhisperError.audioConversionFailed("Conversion returned status \(success.rawValue). Error: \(errorMessage)")
            }
            print("DEBUG: Audio converted to target format.")
        }

        // Extract Float array
        guard let floatChannelData = audioBuffer.floatChannelData else {
            print("ERROR: Failed to get float channel data.")
            throw LocalWhisperError.audioConversionFailed("Failed to get float channel data.")
        }
        let floatArray = Array(UnsafeBufferPointer(start: floatChannelData[0], count: Int(audioBuffer.frameLength)))
        print("DEBUG: Extracted float array for transcription.")

        // Clean up temporary file
        try? FileManager.default.removeItem(at: tempURL)
        print("DEBUG: Temporary audio file removed.")

        let segments = try await whisper.transcribe(audioFrames: floatArray)
        print("DEBUG: Transcription completed.")
        return segments.map(\.text).joined()
    }
}

enum LocalWhisperError: LocalizedError {
    case modelNotLoaded
    case audioConversionFailed(String)

    public var errorDescription: String? {
        switch self {
        case .modelNotLoaded:
            return "Whisper model could not be loaded."
        case .audioConversionFailed(let message):
            return "Audio conversion failed: \(message)"
        }
    }
}
