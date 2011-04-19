class WebBusesController < ApplicationController
  # GET /web_buses
  # GET /web_buses.xml
  def index
    @web_buses = WebBus.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @web_buses }
      format.json  { render :json => @web_buses }
    end
  end

  # GET /web_buses/1
  # GET /web_buses/1.xml
  def show
    @web_bus = WebBus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @web_bus }
    end
  end

  # GET /web_buses/new
  # GET /web_buses/new.xml
  def new
    @web_bus = WebBus.new
    @web_bus.web_locations << WebLocation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @web_bus }
    end
  end

  # GET /web_buses/1/edit
  def edit
    @web_bus = WebBus.find(params[:id])
  end

  # POST /web_buses
  # POST /web_buses.xml
  def create
    @web_bus = WebBus.new(params[:web_bus])

    respond_to do |format|
      @web_bus.web_locations[0].is_current = true
      @web_bus.web_locations[0].is_end = false
      @web_bus.web_locations[0].is_pickup = false
      @web_bus.web_locations[0].is_dropdown = false
      @web_bus.web_locations[0].order_num = 1 
      @web_bus.id = WebBus.maximum(:id) + 1

      if @web_bus.save
        flash[:notice] = 'WebBus was successfully created.'
        format.html { redirect_to(@web_bus) }
        format.xml  { render :xml => @web_bus, :status => :created, :location => @web_bus }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @web_bus.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /web_buses/1
  # PUT /web_buses/1.xml
  def update
    @web_bus = WebBus.find(params[:id])

    respond_to do |format|
      if @web_bus.update_attributes(params[:web_bus])
        flash[:notice] = 'WebBus was successfully updated.'
        format.html { redirect_to(@web_bus) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @web_bus.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /web_buses/1
  # DELETE /web_buses/1.xml
  def destroy
    @web_bus = WebBus.find(params[:id])
    @web_bus.web_locations.each do |web_location|
      web_location.destroy
    end
    @web_bus.web_passengers.each do |web_passenger|
      web_passenger.destroy
    end
    @web_bus.destroy

    respond_to do |format|
      format.html { redirect_to(web_buses_url) }
      format.xml  { head :ok }
    end
  end
end
