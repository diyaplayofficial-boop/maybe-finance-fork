class Provider::Gemini < Provider
  include LlmConcept

  # Subclass so errors caught in this provider are raised as Provider::Gemini::Error
  Error = Class.new(Provider::Error)

  # Latest Gemini models available
  MODELS = %w[gemini-2.0-flash-exp gemini-1.5-pro-latest gemini-1.5-flash-latest gemini-1.5-flash-8b]

  def initialize(api_key)
    require 'net/http'
    require 'json'
    @api_key = api_key
    @base_url = "https://generativelanguage.googleapis.com"
  end

  def supports_model?(model)
    MODELS.include?(model)
  end

  # Auto-categorization and merchant detection not implemented yet for Gemini
  # These features can be added later if needed
  def auto_categorize(transactions: [], user_categories: [])
    raise NotImplementedError, "Auto-categorization not yet implemented for Gemini provider"
  end

  def auto_detect_merchants(transactions: [], user_merchants: [])
    raise NotImplementedError, "Merchant detection not yet implemented for Gemini provider"
  end

  def chat_response(prompt, model:, instructions: nil, functions: [], function_results: [], streamer: nil, previous_response_id: nil)
    with_provider_response do
      # Build the request for Gemini API
      messages = build_gemini_messages(prompt, instructions, functions, function_results)
      
      # Call Gemini API
      response = call_gemini_api(
        model: translate_model_name(model),
        messages: messages
      )

      # Extract content from Gemini response
      content = response.dig("candidates", 0, "content", "parts", 0, "text") || ""
      
      # Return in the format expected by the LlmConcept
      {
        id: SecureRandom.uuid,
        content: content,
        function_tool_calls: []
      }
    end
  end

  private
    attr_reader :api_key, :base_url
    
    def call_gemini_api(model:, messages:)
      uri = URI("#{base_url}/v1beta/models/#{model}:generateContent?key=#{api_key}")
      
      request_body = {
        contents: messages,
        generationConfig: {
          temperature: 0.7,
          maxOutputTokens: 2048,
          topP: 0.95,
          topK: 40
        }
      }
      
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.read_timeout = 30
      http.open_timeout = 30
      
      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = 'application/json'
      request.body = request_body.to_json
      
      response = http.request(request)
      
      if response.code == '200'
        JSON.parse(response.body)
      else
        error_message = begin
          JSON.parse(response.body).dig("error", "message") || response.body
        rescue
          response.body
        end
        raise Error, "Gemini API error (#{response.code}): #{error_message}"
      end
    end

    def translate_model_name(model)
      # Map OpenAI model names to latest Gemini models
      case model
      when "gpt-4.1", "gpt-4", "gpt-4-turbo"
        "gemini-1.5-pro-latest"  # Most capable model
      when "gpt-3.5-turbo"
        "gemini-1.5-flash-latest" # Fast and efficient
      else
        # Default to flash for unknown models
        "gemini-1.5-flash-latest"
      end
    end

    def build_gemini_messages(prompt, instructions, functions, function_results)
      messages = []
      
      # Add system instructions if present
      if instructions.present?
        messages << {
          role: "user",
          parts: [{ text: "System: #{instructions}" }]
        }
        messages << {
          role: "model",
          parts: [{ text: "Understood. I will follow these instructions." }]
        }
      end

      # Add function results if present
      if function_results.present?
        function_text = function_results.map do |result|
          "Function: #{result[:name]}\nResult: #{result[:result]}"
        end.join("\n\n")
        prompt = "#{prompt}\n\n#{function_text}"
      end

      # Add the main prompt
      messages << {
        role: "user",
        parts: [{ text: prompt }]
      }

      messages
    end

end