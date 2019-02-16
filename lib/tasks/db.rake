namespace :db do
    task :seed => :environment do 
        # 仮シードの投入
        # いったんある程度他の機能ができるまでは、この雑なデータで済ませる
        # 頃合いを見計らってスプレッドシートのマスタを参照する形にする

        Character.destroy_all
        Drop.destroy_all
        Equip.destroy_all
        Forge.destroy_all
        Item.destroy_all
        Stage.destroy_all

        Character.create!(
            id: 1,
            name: "イリヤ",
            initial_rarity: 3,
            position: 3
        )

        Drop.create!(
            id: 1,
            stage_id: 1,
            item_id: 1,
            priority: 1
        )
        Drop.create!(
            id: 2,
            stage_id: 1,
            item_id: 2,
            priority: 2
        )
        Drop.create!(
            id: 3,
            stage_id: 2,
            item_id: 1,
            priority: 1
        )

        Equip.create!(
            id: 1,
            character_id: 1,
            item_id: 1,
            position: 1,
            rank: 1
        )

        Forge.create!(
            id: 1,
            forge_item_id: 1,
            material_item_id: 1,
            count: 5
        )

        Item.create!(
            id: 1,
			name: "わしししのはねかざり",
			category: 1,
			is_material: 0,
			hp: 10,
			atk: 0,
			def: 11,
			matk: 0,
			mdef: 12,
			tpgain: 0,
			healgain: 13,
			tpreduce: 0,
			autohp: 0,
			autotp: 0,
			cri: 0,
			mcri: 0,
			hit: 0,
			eva: 0,
            drain: 0
        )
        Item.create!(
            id: 2,
			name: "わしししのはねかざり(欠片)",
			category: 1,
			is_material: 1,
			hp: 0,
			atk: 0,
			def: 0,
			matk: 0,
			mdef: 0,
			tpgain: 0,
			healgain: 0,
			tpreduce: 0,
			autohp: 0,
			autotp: 0,
			cri: 0,
			mcri: 0,
			hit: 0,
			eva: 0,
            drain: 0
        )

        Stage.create!(
            id: 1,
            area: 1,
            location: 1,
            is_hard: 0,
            require_stamina: 5
        )
        Stage.create!(
            id: 2,
            area: 1,
            location: 2,
            is_hard: 0,
            require_stamina: 5
        )

        puts "seeded!"
    end
end