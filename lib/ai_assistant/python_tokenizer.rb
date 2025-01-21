require 'pycall/import'
include PyCall::Import

module AiAssistant
  class PythonTokenizer
    DEFAULT_MODEL = 'gpt2'.freeze

    def initialize(model = DEFAULT_MODEL)
      @tokenizer = load_tokenizer(model)
    end

    # Tokenizes the input content using the Hugging Face tokenizer
    def tokenize(content)
      raise ArgumentError, 'Content cannot be nil or empty' if content.nil? || content.strip.empty?

      begin
        # Tokenize the content with truncation and max length
        tokens = @tokenizer.encode(content, max_length: 512, truncation: true)
        puts "Token length: #{tokens.length}"  # Debugging token length
        tokens
      rescue PyCall::PyError => e
        raise StandardError, "Failed to tokenize content: #{e.message}"
      end
    end

    private

    # Loads the tokenizer, handling exceptions gracefully
    def load_tokenizer(model)
      begin
        pyimport 'transformers', as: 'tf'
        tf.AutoTokenizer.from_pretrained(model)
      rescue PyCall::PyError => e
        raise StandardError, "Failed to load tokenizer for model '#{model}': #{e.message}"
      end
    end
  end
end
