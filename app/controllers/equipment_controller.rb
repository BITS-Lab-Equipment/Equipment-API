class EquipmentController < ApplicationController
  before_action :set_equipment, only: [:show, :update, :destroy]

  def index
    equipment = Equipment.includes(:category).order(:name)
    equipment = equipment.where(status: params[:status]) if params[:status].present?
    render json: equipment.map { |e|
      e.as_json.merge(category_name: e.category.name)
    }
  end

  def show
    render json: @equipment.as_json.merge(
      category: @equipment.category,
      maintenance_records: @equipment.maintenance_records.order(performed_at: :desc)
    )
  end

  def create
    if params[:equipment]&.key?(:category_id)
      category_id = params[:equipment][:category_id]
      unless category_id.blank? || Category.exists?(category_id)
        render json: { errors: ["Category must exist"] }, status: :unprocessable_entity
        return
      end
    end
    equipment = Equipment.new(equipment_params)
    if equipment.save
      render json: equipment, status: :created
    else
      render json: { errors: equipment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if params[:equipment]&.key?(:category_id)
      category_id = params[:equipment][:category_id]
      unless category_id.blank? || Category.exists?(category_id)
        render json: { errors: ["Category must exist"] }, status: :unprocessable_entity
        return
      end
    end
    if @equipment.update(equipment_params)
      render json: @equipment
    else
      render json: { errors: @equipment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @equipment.destroy
    head :no_content
  end

  private

  def set_equipment
    @equipment = Equipment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Equipment not found" }, status: :not_found
  end

  def equipment_params
    params.require(:equipment).permit(:name, :serial_number, :status, :category_id)
  end
end