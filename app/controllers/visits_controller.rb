class VisitsController < ApplicationController
  def index
    @visits = Visit.order(visited_at: :desc)
  end
  
  def new
    @visit = Visit.new
  end
  
  def create
    @visit = Visit.new(visit_params)
    @visit.ip_address = request.remote_ip
    @visit.path = request.path
    @visit.visited_at = Time.current
    
    if @visit.save
      redirect_to visits_path, notice: "Your information was successfully saved!"
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def show
    @visit = Visit.find(params[:id])
  end
  
  private
  
  def visit_params
    params.require(:visit).permit(:name, :email, :age, :comment)
  end
end
