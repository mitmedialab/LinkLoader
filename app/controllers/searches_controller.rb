class SearchesController < ApplicationController
 
  def update_all
    Search.update_all
    render :text => "Updated all", :status => 200
  end
 
  # show the content of the search's featured link by itself in a big iframe
  def featured_link
    # load the search item
    @search = Search.find(params[:id])
    # figure out what the featured link is
    @has_featured_link = @search.has_featured_link?
    @featured_link = Link.find(@search.featured_link_id) if @has_featured_link
    # render it without any of the standard templating
    respond_to do |format|
      format.html { render :layout => "skeletal" }
      format.json { render json: @featured_link}
    end
  end
  
   def most_popular_link
    # load the search item
    @search = Search.find(params[:id])
    # in the last 3 days
    three_days_ago=Time.now.to_i-259200
    # figure out what the most popular link is
    @popular_link = Link.where(:search_id=>@search.id).
      where("strftime('%s',first_tweeted)>'"+three_days_ago.to_s+"'").
      order("frequency DESC, first_tweeted DESC").first
    # render it without any of the standard templating
    respond_to do |format|
      format.html { render :layout => "skeletal" }
      format.json { render json: @popular_link}
    end
   end
    
   def random_link
    # load the search item
    @search = Search.find(params[:id])
    # in the last 3 days
    three_days_ago=Time.now.to_i-259200
    # figure out what the most popular link is
    @random_link = Link.where(:search_id=>@search.id).
      where("strftime('%s',first_tweeted)>'"+three_days_ago.to_s+"'").
      order("random()").first
    # render it without any of the standard templating
    respond_to do |format|
      format.html { render :layout => "skeletal" }
      format.json { render json: @random_link}
    end
  end
  
  def stream
    # load the search item
    @search = Search.find(params[:id])
    respond_to do |format|
      format.html { render :layout => "skeletal" }
    end
  end
  
   def stream_details
    # load the search item
    @search = Search.find(params[:id])
    @tweets = @search.get_stream
    respond_to do |format|
      format.html { render :layout => nil }
      format.json { render json: @tweets}
    end
  end

  def links
    @search = Search.find(params[:id])
    @recent_links = Link.where(:search_id => @search.id).order('first_tweeted DESC').limit(100)
    @featured_link = Link.find(@search.featured_link_id) if @search.has_featured_link?
  end  
  
  def update_results
    @search = Search.find(params[:id])
    @search.update_results
    redirect_to '/searches/'+@search.id.to_s+'/links'
  end
  # GET /searches
  # GET /searches.json
  
  def index
    @searches = Search.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @searches }
    end
  end

  # GET /searches/1
  # GET /searches/1.json
  def show
    @search = Search.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @search }
    end
  end

  # GET /searches/new
  # GET /searches/new.json
  def new
    @search = Search.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @search }
    end
  end

  # GET /searches/1/edit
  def edit
    @search = Search.find(params[:id])
  end

  # POST /searches
  # POST /searches.json
  def create
    @search = Search.new(params[:search])

    respond_to do |format|
      if @search.save
        format.html { redirect_to @search, notice: 'Search was successfully created.' }
        format.json { render json: @search, status: :created, location: @search }
      else
        format.html { render action: "new" }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /searches/1
  # PUT /searches/1.json
  def update
    @search = Search.find(params[:id])

    respond_to do |format|
      if @search.update_attributes(params[:search])
        format.html { redirect_to @search, notice: 'Search was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search = Search.find(params[:id])
    @search.destroy

    respond_to do |format|
      format.html { redirect_to searches_url }
      format.json { head :no_content }
    end
  end
end
