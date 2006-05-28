module Arts
  include ActionView::Helpers::PrototypeHelper
  include ActionView::Helpers::ScriptaculousHelper
  include ActionView::Helpers::JavaScriptHelper
    
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  
  def assert_rjs(action, *args, &block)
    return assert_rjs_insert_html(action, *args) if action.to_sym == :insert_html
    assert lined_response.include?(create_generator.send(action, *args, &block)), "#{action} with args [#{args.join(" ")}] does not show up in response"
  end
  
  def assert_rjs_insert_html(action, *args)
    position = args.shift
    item_id = args.shift
    content = args.shift

    assert lined_response.include?("new Insertion.#{position.to_s.camelize}(\"#{item_id}\", \"#{content}\");")
  end
  
  protected
  
  def lined_response
    @response.body.split("\n")
  end
  
  def create_generator
    block = Proc.new { |*args| yield *args if block_given? } 
    JavaScriptGenerator.new self, &block
  end
end
