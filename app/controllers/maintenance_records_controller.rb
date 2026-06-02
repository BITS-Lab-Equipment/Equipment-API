class MaintenanceRecordsController < ApplicationController
  before_action :set_maintenance_record, only: [:show, :update, :destroy]

  def index
    records = MaintenanceRecord.includes(:equipment).order(performed_at: :desc)
    records = records.where(equipment_id: params[:equipment_id]) if params[:equipment_id].present?
    render json: records.map { |r|
      r.as_json.merge(equipment_name: r.equipment.name)
    }
  end

  def show
    render json: @record.as_json.merge(equipment_name: @record.equipment.name)
  end

  def create
    if params[:maintenance_record]&.key?(:equipment_id)
      equipment_id = params[:maintenance_record][:equipment_id]
      unless equipment_id.blank? || Equipment.exists?(equipment_id)
        render json: { errors: ["Equipment must exist"] }, status: :unprocessable_entity
        return
      end
    end
    record = MaintenanceRecord.new(maintenance_record_params)
    if record.save
      render json: record, status: :created
    else
      render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @record.update(maintenance_record_params)
      render json: @record
    else
      render json: { errors: @record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @record.destroy
    head :no_content
  end

  private

  def set_maintenance_record
    @record = MaintenanceRecord.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "MaintenanceRecord not found" }, status: :not_found
  end

  def maintenance_record_params
    params.require(:maintenance_record).permit(:description, :performed_at, :equipment_id)
  end
end