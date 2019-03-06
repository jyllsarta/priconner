class EquipsController < ApplicationController
    def index
        @equip = Equip.new
        @equips = Equip.all
    end

    def show
        @equip = Equip.find_by(id: params[:id])
    end
end
