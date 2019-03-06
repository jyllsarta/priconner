class DropsController < ApplicationController
    def index
        @drop = Drop.new
        @drops = Drop.all
    end

    def show
        @drop = Drop.find_by(id: params[:id])
    end
end
