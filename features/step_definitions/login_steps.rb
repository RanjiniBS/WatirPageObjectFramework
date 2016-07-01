Given(/^user should navigate to Jquery UI application$/) do
  visit_page JqueryLoginPage
end

Then(/^user able to verify Jquery UI Page Header$/) do
  on_page JqueryLoginPage do |login_page|
    login_page.verify_page_header
  end
end

Then(/^user able to verify Jquery UI Support Image$/) do
  on_page JqueryLoginPage do |login_page|
    login_page.verify_support_image
  end
end

Then(/^user able to verify mouseover$/) do
  on_page JqueryLoginPage do |login_page|
    login_page.verify_mouse_over
  end
end

Then(/^user able to verify drag and drop$/) do
  on_page JqueryLoginPage do |login_page|
    login_page.verify_drag_and_drop
    login_page.mouse_event1
  end
end

Then(/^user able to sortable the items$/) do
  on_page JqueryLoginPage do |login_page|
    login_page.verify_drag_and_drop
    login_page.sortable_items
  end
end

Then(/^user able to handle tooltip$/) do
  on_page JqueryLoginPage do |login_page|
    login_page.tool_tip
    login_page.verify_tooltip_page_header
    login_page.handling_tooltip
  end
end
