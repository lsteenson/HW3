require 'spec_helper'

describe MoviesController do
	before :each do
		@a_movie = stub('double').as_null_object
		@movie = [mock('movie1')]
	end
	
	describe "show the index" do
    it "should render_template 'index'" do
      get :index
      response.should render_template 'index'
    end
    it "should sort info" do
    	get :index, :order => :title
    end
    it "should sort info by date" do
    	get :index, :order => :release_date 
    end
  end
	
	describe 'change info of an existing movie' do
		before :each do
			movie_id = 5
			Movie.should_receive(:find).with(movie_id.to_s).and_return(@a_movie)
			@a_movie.should_receive(:update_attributes!).exactly 1
			put :update, {:id => movie_id, :movie => @movie}
		end
		it 'has to return list of all ratings' do
      r = Movie.all_ratings
      r.length.should == 4
    end
		it 'should call a model method to change the info' do
			true
		end
		it 'should redirect to show template for rendering' do
			response.should redirect_to(movie_path @a_movie)
		end
		it 'new info should be available' do
			assigns(:movie).should == @a_movie
		end
	end
	
	describe 'make a new movie' do
		it 'should render the new template' do
			get :new
			response.should render_template 'new'
		end
		it 'should call a model method to post data' do
			movie = stub('new movie').as_null_object
			Movie.should_receive(:create!).and_return(movie)
			post :create, {:movie => movie}
		end
		it 'should render index template' do
			movie = stub('new movie').as_null_object
			Movie.stub(:create!).and_return(movie)
			post :create, {:movie => movie}
			response.should redirect_to(movies_path)
		end
	end
	
	describe 'destroy an existing movie' do
		it 'should render edit movie template' do
			Movie.stub(:find)
			get :edit, {:id => 5}
			response.should render_template 'edit'
		end
		it 'should call a model method to update data' do
			my_movie = mock('a movie').as_null_object
			Movie.should_receive(:find).and_return(my_movie)
			my_movie.should_receive(:destroy)
			delete :destroy, {:id => 1}
		end
	end
	
	describe 'show movies by same director' do
		before :each do
			@movie_id = 10
			@movs = [mock('a movie'), mock('and another')]
			@a_movie.stub(:director).and_return('a director')
		end
		
		it 'should show the index with only the apropriate movies' do
			Movie.stub(:find).and_return(@a_movie)
			Movie.stub(:find_all_by_director).and_return(@movs)

			get :sorted, {:id => @movie_id}
			response.should render_template("layouts/application")
		end
		
		it 'should call Model method to get movies with same director' do
			Movie.should_receive(:find).with(@movie_id.to_s).and_return(@a_movie)
			Movie.should_receive(:find_all_by_director).and_return(@movs)

			get :sorted, {:id => @movie_id}
		end
		
		it 'should make apropriate movies available to the view' do
			Movie.stub(:find).and_return(@a_movie)
			Movie.stub(:find_all_by_director).and_return(@movs)
			get :sorted, {:id => @movie_id}
			assigns(:movies).should == @movs
		end
		
		it 'should display index if no movies match' do
			empty_director =  double('movie', :director => '').as_null_object
			Movie.stub(:find).and_return(empty_director)
			Movie.stub(:find_all_by_director)

			get :sorted, {:id => @movie_id}
			response.should redirect_to(movies_path)						
		end
	end
end
