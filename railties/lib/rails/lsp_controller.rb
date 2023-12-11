# frozen_string_literal: true

require "rails/application_controller"

class Rails::LspController < Rails::ApplicationController # :nodoc:
  class ModelNotFound < RuntimeError; end

  before_action :require_local!

  def show
    model_name = params[:name]
    result = resolve_database_info_from_model(model_name)
    render json: result
  rescue ModelNotFound
    render json: { error: "Model not found" }
  end

  private
    def resolve_database_info_from_model(model_name)
      const = ActiveSupport::Inflector.safe_constantize(model_name)

      if const && const < ActiveRecord::Base
        begin
          schema_file = ActiveRecord::Tasks::DatabaseTasks.schema_dump_path(const.connection.pool.db_config)
        rescue => e
          warn("Could not locate schema: #{e.message}")
        end

        body = {
          columns: const.columns.map { |column| [column.name, column.type] },
          schema_file: schema_file,
        }

        body
      else
        raise ModelNotFound
      end
    end
end
