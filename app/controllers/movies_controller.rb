class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings

    
    if (params[:ratings] != nil)
       session[:ratings] = Hash[params[:ratings].keys.map {|x| [x, nil]}]
    else
       session[:ratings] = session[:ratings].keys.length > 0 ? session[:ratings] : Hash[@all_ratings.map {|x| [x, nil]}]
       redirect = true
    end

    if (params[:order] != nil)
       session[:order] = params[:order]
    else
       session[:order] = session[:order].length > 0 ? session[:order] : [:noorder]
       redirect = true
    end

    if (redirect == true)
       flash.keep
       redirect_to movies_path({ :order => session[:order], :ratings => session[:ratings] })
    else
    
    @ratings_checked = session[:ratings]
    if params[:order] == ["noorder"]
       params[:order]=[]
    end
    if session[:ratings].length > 0
       @movies = Movie.find_all_by_rating(session[:ratings].keys, :order => params[:order])
    else
       @movies = Movie.find :all, :order => params[:order]
    end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
