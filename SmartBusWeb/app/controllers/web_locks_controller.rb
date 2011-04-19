class WebLocksController < ApplicationController
  # GET /web_locks
  # GET /web_locks.xml
  def index
    @web_locks = WebLock.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @web_locks }
    end
  end

  # GET /web_locks/1
  # GET /web_locks/1.xml
  def show
    @web_lock = WebLock.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @web_lock }
    end
  end

  # GET /web_locks/new
  # GET /web_locks/new.xml
  def new
    @web_lock = WebLock.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @web_lock }
    end
  end

  # GET /web_locks/1/edit
  def edit
    @web_lock = WebLock.find(params[:id])
  end

  # POST /web_locks
  # POST /web_locks.xml
  def create
    @web_lock = WebLock.new(params[:web_lock])

    respond_to do |format|
      if @web_lock.save
        flash[:notice] = 'WebLock was successfully created.'
        format.html { redirect_to(@web_lock) }
        format.xml  { render :xml => @web_lock, :status => :created, :location => @web_lock }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @web_lock.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /web_locks/1
  # PUT /web_locks/1.xml
  def update
    @web_lock = WebLock.find(params[:id])

    respond_to do |format|
      if @web_lock.update_attributes(params[:web_lock])
        flash[:notice] = 'WebLock was successfully updated.'
        format.html { redirect_to(@web_lock) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @web_lock.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /web_locks/1
  # DELETE /web_locks/1.xml
  def destroy
    @web_lock = WebLock.find(params[:id])
    @web_lock.destroy

    respond_to do |format|
      format.html { redirect_to(web_locks_url) }
      format.xml  { head :ok }
    end
  end
end
