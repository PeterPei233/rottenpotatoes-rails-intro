class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @movies = Movie.all
    redirect = false

    if params[:ratings]
      session[:ratings] = params[:ratings]
      @movies = Movie.find_ratings(params[:ratings].keys)
    else 
      redirect = true
    end
    if params[:sort_by]
      session[:sort_by] = params[:sort_by]
      @movies = @movies.order("#{params[:sort_by]} ASC")
    else 
      redirect = true
    end
    if redirect 
      flash.keep
      if (params[:sort_by].nil? && params[:ratings].nil? && session[:sort_by] && session[:ratings])
        redirect_to movies_path :sort_by => session[:sort_by], :ratings => session[:ratings]
      elsif (params[:ratings].nil? && session[:ratings])
        redirect_to movies_path :sort_by => params[:sort_by], :ratings => session[:ratings]
      elsif (params[:sort_by].nil? && session[:sort_by])
        redirect_to movies_path :sort_by => session[:sort_by], :ratings => params[:ratings]
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
