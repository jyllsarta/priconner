class ForgesController < ApplicationController
    def index
        @forge = Forge.new
        @forges = Forge.all
    end

    def show
        @forge = Forge.find_by(id: params[:id])
    end
end
