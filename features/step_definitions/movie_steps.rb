# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
   assert result
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW3. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # You should arrange to add that movie to the database here.
    # You can add the entries directly to the databasse with ActiveRecord methodsQ
    Movie.create!(movie)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |rating_list|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  Movie.all_ratings.each do |all|
  	all = "ratings_" + all
  	uncheck(all)
  end
  rl = rating_list.split(', ')
  rl.each do |rt|
  	rt = "ratings_" + rt
  	check(rt)
  end
end

Then /^I should see only movies rated "(.*?)"$/ do |ratings_list|
	ratings = ratings_list.split(", ")
	db_size = Movie.find(:all, :conditions => {:rating => ratings}).size
	rows = page.all("table tr").count - 1
end

Then /^I should see all of the movies$/ do
	db_size = Movie.all.size
	rows = page.all("table tr").count - 1
  rows.should == db_size
end

When /^I have opted to see "(.*?)" before "(.*?)"$/ do |movie1, movie2|
  click_link('title_header')
  first = page.body.split(movie1,2)
  second = page.body.split(movie2, 2)
  fl = first[0].length
  sl = second[0].length
  if fl > sl
    click_link('release_date_header')
  end
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |movie1, movie2|
	first = page.body.split(movie1,2)
  second = page.body.split(movie2, 2)
  fl = first[0].length
  sl = second[0].length
  fl.should < sl
end



When /^I have edited the movie "(.*?)" to change the director to "(.*?)"$/ do |title, director|
  visit movies_path
  click_on "More about #{title}"
  click_on 'Edit'
  fill_in 'Director', :with => director
  click_button 'Update Movie Info' 
end

When /^I am on the Rotten Potatoes home page$/ do
  visit movies_path
end

Then /^I should see a movie list entry with title "(.*?)" and director  "(.*?)"$/ do |title, director|
  result=false
    all("tr").each do |tr|
      if tr.has_content?(director) && tr.has_content?(title)
        result = true
        break
    end
  end  
  assert result
end

When /^I have opted to view movies with the same director$/ do
  click_on "Find movies by same director"
end

Then /^I should see a movie list entry with title "(.*?)" and director "(.*?)"$/ do |title, director|
  result=false
    all("tr").each do |tr|
      if tr.has_content?(director) && tr.has_content?(title)
        result = true
        break
    end
  end  
  assert result
end

Then /^I should not see a movie list entry with title  "(.*?)" and director "(.*?)"$/ do |title, director|
  result=true
    all("tr").each do |tr|
      if tr.has_content?(director) && tr.has_content?(title)
        result = false
        break
    end
  end  
  assert result
end

Then /^I should not see "(.*?)"$/ do |director|
  if page.respond_to? :should
    page.should_not have_content(director)
  else
    assert !page.has_content?(director)
  end
end

When /^I have opted to view movies by the same director$/ do
  click_on "Find movies by same director"
end



