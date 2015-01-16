class EntriesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def show
    @entry = Entry.find(params[:id])
    @comments = @entry.comments.paginate(page: params[:page])
  end

  def create
    @entries = current_user.entries.build entry_params
    if @entries.save
      flash[:success] = "Entry created!"
      redirect_to root_url
    else
      @feed_items = []
      redirect_to root_url
    end
  end

  def destroy
    @entry.destroy
    flash[:success] = "Entry deleted"
    redirect_to request.referrer || root_url
  end

  private

  def entry_params
    params.require(:entry).permit(:title, :body)
  end

  def correct_user
    @entry = current_user.entries.find_by(id: params[:id])
    redirect_to root_url if @entry.nil?
  end
end
