class TicketsController < ApplicationController
  before_action :set_project
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  def new
    @ticket = @project.tickets.build
    @ticket.assets.build
    authorize @ticket, :create?
  end

  def create
    @ticket = @project.tickets.build(ticket_params)
    @ticket.author = current_user
    authorize @ticket, :create?

    if @ticket.save
      flash[:success] = "Ticket has been created."
      redirect_to [@project, @ticket]
    else
      flash[:error] = "Ticket has not been created."
      render "new"
    end
  end

  def show
    authorize @ticket, :show?
  end

  def edit
    authorize @ticket, :update?
  end

  def update
    authorize @ticket, :update?

    if @ticket.update(ticket_params)
      flash[:success] = "Ticket has been updated."
      redirect_to [@project, @ticket]
    else
      flash[:error] = "Ticket has not been updated."
      render action: "edit"
    end
  end

  def destroy
    authorize @ticket, :destroy?
    @ticket.destroy
    flash[:success] = "Ticket has been deleted."

    redirect_to @project
  end

  private
    def ticket_params
      params.require(:ticket).permit(:title, :description,
        assets_attributes: [:asset, :asset_cache])
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_ticket
      @ticket = @project.tickets.find(params[:id])
    end
end
