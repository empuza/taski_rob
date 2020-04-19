module Admin
  module Users
    class TasksController < ApplicationController
      before_action :authorize_access_request!
      before_action :set_user
      ROLES = %w[admin manager].freeze

      def index
        render json: @user.tasks
      end

      def token_claims
        {
            aud: ROLES,
            verify_aud: true
        }
      end

      private

      def set_user
        @user = User.find(params[:user_id])
      end
    end
  end
end
