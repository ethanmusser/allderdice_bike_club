class EventPostsController < ApplicationController

  #->Prelang (scaffolding:rails/scope_to_user)
  before_filter :require_user_signed_in, only: [:new, :edit, :create, :update, :destroy]

  before_action :set_event_post, only: [:show, :edit, :update, :destroy]

  # GET /event_posts
  # GET /event_posts.json
  def index
    @event_posts = EventPost.all
  end

  # GET /event_posts/1
  # GET /event_posts/1.json
  def show
  end

  # GET /event_posts/new
  def new
    @event_post = EventPost.new
  end

  # GET /event_posts/1/edit
  def edit
  end

  # POST /event_posts
  # POST /event_posts.json
  def create
    @event_post = EventPost.new(event_post_params)
    @event_post.user = current_user

    respond_to do |format|
      if @event_post.save
        format.html { redirect_to @event_post, notice: 'Event post was successfully created.' }
        format.json { render :show, status: :created, location: @event_post }
      else
        format.html { render :new }
        format.json { render json: @event_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_posts/1
  # PATCH/PUT /event_posts/1.json
  def update
    respond_to do |format|
      if @event_post.update(event_post_params)
        format.html { redirect_to @event_post, notice: 'Event post was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_post }
      else
        format.html { render :edit }
        format.json { render json: @event_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_posts/1
  # DELETE /event_posts/1.json
  def destroy
    @event_post.destroy
    respond_to do |format|
      format.html { redirect_to event_posts_url, notice: 'Event post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  #->Prelang (voting/acts_as_votable)
  def vote

    direction = params[:direction]

    # Make sure we've specified a direction
    raise "No direction parameter specified to #vote action." unless direction

    # Make sure the direction is valid
    unless ["like", "bad"].member? direction
      raise "Direction '#{direction}' is not a valid direction for vote method."
    end

    @event_post.vote_by voter: current_user, vote: direction

    redirect_to action: :index
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_post
      @event_post = EventPost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_post_params
      params.require(:event_post).permit(:user_id, :title, :author, :event_name, :event_date_time, :event_description)
    end
end
