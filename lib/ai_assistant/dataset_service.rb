require 'json'

module AiAssistant
  class DatasetService
    def initialize(output_file = "#{Rails.root}/dataset.json", tokenizer = nil)
      @output_file = output_file
      @tokenizer = tokenizer || AiAssistant::PythonTokenizer.new('gpt2')
    end

    # Reads all files starting from the Rails root and creates a dataset
    def build_dataset
      root_directory = Rails.root
      dataset = []

      # Traverse all files starting from Rails.root
      Dir.glob(File.join(root_directory, '**', '*')).each do |file|
        next unless File.file?(file) # Skip directories

        begin
          # Read the file content
          content = File.read(file)

          # Tokenize the content
          tokens = tokenize_content(content)

          dataset << { file_path: file, tokens: tokens } if tokens.any?
        rescue => e
          puts "Error processing file #{file}: #{e.message}"
        end
      end

      # Save the dataset to a JSON file
      save_dataset(dataset)
      puts "Dataset created at #{@output_file}"
    end

    private

    # Tokenizes content using the specified tokenizer
    def tokenize_content(content)
      @tokenizer.tokenize(content)
    rescue => e
      puts "Error tokenizing content: #{e.message}"
      []
    end

    # Saves the dataset as a JSON file
    def save_dataset(dataset)
      File.open(@output_file, 'w') do |file|
        file.write(JSON.pretty_generate(dataset))
      end
    end
  end
end
