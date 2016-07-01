require 'rspec/expectations'
class  JqueryLoginPage
  include PageObject
  include RSpec::Matchers

  url = CONFIGFILE['global']['url']
  direct_url(url)

  def verify_page_header
    @@page_header = @browser.a(:text,"jQuery UI")
    expect(@@page_header.visible?).to be_truthy
    if @@page_header.present?
      @@page_header.click
      $log.info("Page Header found")
    else
      $log.error("Page Header is not found")
      raise Exception.new("Unable to found page Header")
    end

    def verify_support_image
      @@image = @browser.a(:title, "Support the jQuery Foundation")
      expect(@@image.visible?).to be_truthy
      if @@image.present?
        $log.info "Image is found"
      else
        $log.error "Image is not found"
        raise Exception.new("Failed to found Image")
      end
    end

    def verify_mouse_over
      @@mouse_over = @browser.a(:text, "Contribute")
      expect(@@mouse_over.visible?).to be_truthy
      @@mouse_over.hover

      @@mouse_over1 =@browser.a(:text, "Support")
      expect(@@mouse_over1.visible?).to be_truthy
      @@mouse_over1.fire_event("onmouseover")
      #sleep 2
    end

    def handling_unordered_list
      @mouse_over = @browser.a(:text, "Contribute").hover
      @unordered_list = @browser.ul(:xpath, "//div/ul[2]/li[2]/ul")
      @unordered_list.exists?
      @unordered_list.text
      puts @unordered_list
    end

    def verify_drag_and_drop
      @@drag_and_drop = @browser.a(:text, "Sortable")
      expect(@@drag_and_drop.visible?).to be_truthy
      if @@drag_and_drop.present?
        @@drag_and_drop.click
        $log.info "Link is found"
      else
        $log.error "Link not found"
        raise Exception.new("Failed to found Link")
      end
    end

    def mouse_event1
      sleep 5
      @@element1 = @browser.iframe(:class, "demo-frame").div(:id, "draggable")
     # expect(@@element1.visible?).to be_truthy
      @@element2 = @browser.iframe(:class, "demo-frame").div(:id,"droppable")
      #expect(@@element2.visible?).to be_truthy

      @@element1.drag_and_drop_on @@element2
    end

    def mouse_event2
      sleep 5
      @@element1 = @browser.iframe(:class, "demo-frame").div(:id, "draggable")
      @@element2 = @browser.iframe(:class, "demo-frame").div(:id,"droppable")
      # resize = @browser.div(:id, "resizable")
      # # @a.drag_and_drop_by 100, -200
      # resize.drag_and_drop_by(400, 200)
    end


    def mouse_event3
      sleep 5
      @a = @browser.iframe(:class, "demo-frame").div(:id, "draggable")
      @b = @browser.iframe(:class, "demo-frame").div(:id,"droppable")

      @a.fire_event("onmouseup")
      sleep 2
      @b.fire_event("onmouseup")
      sleep 2

      @a.fire_event("onmousedown")
      sleep 2
      @b.fire_event("onmousedown")
      sleep 2
    end

    def mouse_event4
      sleep 3
      @browser.a(:text, "Support").fire_event("onmouseover")
    end

    def sortable_items
      sleep 3
      @item1 = @browser.ul(:id, "sortable").li(:text,"Item 1")
      @item2 = @browser.ul(:id, "sortable").li(:text,"Item 2")

      @item1.drag_and_drop_on @item2
      sleep 5
    end

    def tool_tip
      @tool_tip = @browser.a(:text, "Tooltip")
      if @tool_tip.exists?
        @tool_tip.click
        sleep 10
        $log.debug "Link is found"
      else
        $log.error "Link not found"
        raise Exception.new("Failed to found Link")
      end
    end

    def verify_tooltip_page_header
      @page_header = @browser.h1(:text, "Tooltip")
      if @page_header.exists?
        $log.debug "Page Header is found"
      else
        $log.error "Page Header is not found"
        raise Exception.new("Failed to found Page header")
      end
    end

    def handling_tooltip
      @browser.iframe(:class, "demo-frame").input(:id,"age").hover
      #.fire_event('onmouseover')
      # .hover
      @browser.text.expect == "We ask for your age only for statistical purposes."
    end

  end
end

