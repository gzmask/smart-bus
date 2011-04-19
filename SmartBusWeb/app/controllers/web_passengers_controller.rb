class WebPassengersController < ApplicationController
  # GET /web_passengers
  # GET /web_passengers.xml
  def index
    @web_passengers = WebPassenger.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @web_passengers }
      format.json  { render :json => @web_passengers }
    end
  end

  # GET /web_passengers/1
  # GET /web_passengers/1.xml
  def show
    @web_passenger = WebPassenger.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @web_passenger }
    end
  end

  # GET /web_passengers/new
  # GET /web_passengers/new.xml
  def new
    @web_passenger = WebPassenger.new
    @web_passenger.web_locations << WebLocation.new
    @web_passenger.web_locations << WebLocation.new
 
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @web_passenger }
    end
  end

  # GET /web_passengers/1/edit
  def edit
    @web_passenger = WebPassenger.find(params[:id])
  end

  # POST /web_passengers
  # POST /web_passengers.xml
  def create
    @web_passenger = WebPassenger.new(params[:web_passenger])

    respond_to do |format|
      @web_passenger.web_locations[0].is_pickup = true
      @web_passenger.web_locations[0].is_dropdown = false
      @web_passenger.web_locations[1].is_pickup = false
      @web_passenger.web_locations[1].is_dropdown = true

      web_loc_pick = WebLocation.find(:first, :conditions => ["latitude = ? and longitude = ?", @web_passenger.web_locations[0].latitude, @web_passenger.web_locations[0].longitude])
      while web_loc_pick != nil
        @web_passenger.web_locations[0].latitude = (@web_passenger.web_locations[0].latitude.to_s << rand(9).to_s).to_f
        @web_passenger.web_locations[0].longitude = (@web_passenger.web_locations[0].longitude.to_s << rand(9).to_s).to_f
        web_loc_pick = WebLocation.find(:first, :conditions => ["latitude = ? and longitude = ?", @web_passenger.web_locations[0].latitude, @web_passenger.web_locations[0].longitude])
      end

      web_loc_drop = WebLocation.find(:first, :conditions => ["latitude = ? and longitude = ?", @web_passenger.web_locations[1].latitude, @web_passenger.web_locations[1].longitude])
      while web_loc_drop != nil
        @web_passenger.web_locations[1].latitude = (@web_passenger.web_locations[1].latitude.to_s << rand(9).to_s).to_f
        @web_passenger.web_locations[1].longitude = (@web_passenger.web_locations[1].longitude.to_s << rand(9).to_s).to_f
        web_loc_drop = WebLocation.find(:first, :conditions => ["latitude = ? and longitude = ?", @web_passenger.web_locations[1].latitude, @web_passenger.web_locations[1].longitude])
      end

      if @web_passenger.save
        flash[:notice] = 'WebPassenger was successfully created.'
        format.html { redirect_to(@web_passenger) }
        format.xml  { render :xml => @web_passenger, :status => :created, :location => @web_passenger }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @web_passenger.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /web_passengers/1
  # PUT /web_passengers/1.xml
  def update
    @web_passenger = WebPassenger.find(params[:id])

    respond_to do |format|
      if @web_passenger.update_attributes(params[:web_passenger])
        flash[:notice] = 'WebPassenger was successfully updated.'
        format.html { redirect_to(@web_passenger) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @web_passenger.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /web_passengers/1
  # DELETE /web_passengers/1.xml
  def destroy
    @web_passenger = WebPassenger.find(params[:id])
    @web_passenger.web_locations.each do |web_location|
      web_location.destroy
    end
    @web_passenger.destroy

    respond_to do |format|
      format.html { redirect_to(web_passengers_url) }
      format.xml  { head :ok }
    end
  end
end
