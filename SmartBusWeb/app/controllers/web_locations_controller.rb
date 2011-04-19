class WebLocationsController < ApplicationController
  # GET /web_locations
  # GET /web_locations.xml
  def index
   @web_locations = WebLocation.find(:all, :order => "web_bus_id, order_num ASC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @web_locations }
      format.json  { render :json => @web_locations }
    end
  end

  # GET /web_locations/1
  # GET /web_locations/1.xml
  def show
    @web_location = WebLocation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @web_location }
    end
  end


  # GET /web_locations/new
  # GET /web_locations/new.xml
  def new
    @web_location = WebLocation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @web_location }
    end
  end

  # GET /web_locations/1/edit
  def edit
    @web_location = WebLocation.find(params[:id])
  end

  # POST /web_locations
  # POST /web_locations.xml
  def create
    @web_location = WebLocation.new(params[:web_location])

    respond_to do |format|
      if @web_location.save
        flash[:notice] = 'WebLocation was successfully created.'
        format.html { redirect_to(@web_location) }
        format.xml  { render :xml => @web_location, :status => :created, :location => @web_location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @web_location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /web_locations/1
  # PUT /web_locations/1.xml
  def update
    @web_location = WebLocation.find(params[:id])

    respond_to do |format|
      if @web_location.update_attributes(params[:web_location])
        flash[:notice] = 'WebLocation was successfully updated.'
        format.html { redirect_to(@web_location) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @web_location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /web_locations/1
  # DELETE /web_locations/1.xml
  def destroy
    @web_location = WebLocation.find(params[:id])
    @web_location.destroy

    respond_to do |format|
      format.html { redirect_to(web_locations_url) }
      format.xml  { head :ok }
    end
  end

  def monitor
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([50.4493, -104.617],13)
    @web_locations = WebLocation.find(:all, :order => "web_bus_id, order_num ASC")

    respond_to do |format|
      format.html # index.html.erb
    end
  end

end
