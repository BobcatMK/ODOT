require "rails_helper"

describe "Editing todo lists" do
  let!(:todo_list) {TodoList.create(title: "Groceries",description: "Grocery List.")}
  
  def update_todo_list(options={}) 
    options[:title] ||= "My todo list"
    options[:description] ||= "This is my todo list."
    
    todo_list = options[:todo_list]
    
    visit "/todo_lists"
    within "#todo_list_#{todo_list.id}" do
      click_link "Edit"
    end
    
    fill_in "Title",with: options[:title]
    fill_in "Description",with: options[:description]
    click_button "Update Todo list"
  end
  
  it "updates a todo list successfully with correct information" do
    update_todo_list(:todo_list => todo_list,:title => "New title",:description => "New description")
    
    todo_list.reload # This is realoading database and assigining it to todo_list,
    # we have to do it because otherwise test will fail, why? due to fact that it's
    # evaluating todo_list based on memory value, not database value. 
    
    expect(page).to have_content("Todo list was successfully updated")
    expect(todo_list.title).to eq("New title")
    expect(todo_list.description).to eq("New description")
  end
  
  # Displays an error with no title
  it "Displays an error with no title" do
    update_todo_list(:todo_list => todo_list,:title => "")
    todo_list.reload
    expect(page).to have_content("error")
  end
  # Displays an error with too short title
  it "Displays an error with too short title" do
    update_todo_list(:todo_list => todo_list,:title => "Ab")
    todo_list.reload
    expect(page).to have_content("error")
  end
  # Displays an error with no description
  it "Displays an error with no description" do
    update_todo_list(:todo_list => todo_list,:description => "")
    todo_list.reload
    expect(page).to have_content("error")
  end
  # Displays an error with too short description
  it "Displays an error with too short description" do
    update_todo_list(:todo_list => todo_list,:description => "123456789")
    todo_list.reload
    expect(page).to(have_content("error"))
  end
end

