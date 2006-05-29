module Arts
  include ActionView::Helpers::PrototypeHelper
  include ActionView::Helpers::ScriptaculousHelper
  include ActionView::Helpers::JavaScriptHelper
    
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  
  def assert_rjs(action, *args, &block)
    case action.to_sym
      when :insert_html
        return assert_rjs_insert_html(*args)
      when :replace_html
        return assert_rjs_replace_html(*args)
      else
        assert lined_response.include?(create_generator.send(action, *args, &block)), 
               generic_error(action, args)
    end
  end
  
  def assert_rjs_insert_html(*args)
    position = args.shift
    item_id = args.shift
    content = args.shift

    assert lined_response.include?("new Insertion.#{position.to_s.camelize}(\"#{item_id}\", \"#{content}\");"),
           "No insert_html call found for position: '#{position}' id: '#{item_id}' content: '#{content}'"
  end
  
  def assert_rjs_replace_html(*args)
    div = args.shift
    content = args.shift
    
    assert lined_response.include?("Element.update(\"#{div}\", \"#{content}\");"), 
           "No replace_html call found on div: '#{div}' and content: '#{content}'"
  end
  
  protected
  
  def lined_response
    @response.body.split("\n")
  end
  
  def create_generator
    block = Proc.new { |*args| yield *args if block_given? } 
    JavaScriptGenerator.new self, &block
  end
  
  def generic_error(action, args)
    "#{action} with args [#{args.join(" ")}] does not show up in response"
  end
end
