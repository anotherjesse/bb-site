class LibrariesController < ApplicationController

  def index
    @libraries = Library.find(:all)
  end

  def show
    @library = Library.find(params[:id])

    # TODO: cache to the filesystem
    render :json => @library.to_json if params[:format] == :json
  end

  def edit
    @library = Library.find(params[:id])
  end

  def update
    @library = Library.find(params[:id])
    if admin?
      @library.update_attributes params[:library]
    end
    redirect_to library_path(@library)
  end

end
