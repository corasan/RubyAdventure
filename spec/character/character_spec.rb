require "pry"
# TODO add validation for subject attributes. Ex: Health cannot go over 100 etc
describe Character do
  subject { Character.new }
  let(:full_character) do
    Character.new(
      health: 110,
      level: 2,
      attack: 25,
      defense: 40,
      money: 100,
      exp: 0
    )
  end
  describe "#initialize" do
    context "when no arguments passed in" do
      it "has default values" do
        expect(subject).to have_attributes(
          name: 'Nameless One',
          health: 100,
          level: 1,
          attack: 10,
          defense: 10,
          money: 0,
          experience: 0,
          equipped_weapons: [],
          equipped_armor: [],
          weapon_count: 0,
          armor_count: 0,
          potion_count: 0
        )
      end
    end
    context "when arguments passed in" do
      it "has passed in values" do
        expect(full_character).to have_attributes(
          name: 'Nameless One',
          health: 110,
          level: 2,
          attack: 25,
          defense: 40,
          money: 100,
          experience: 0,
          equipped_weapons: [],
          equipped_armor: [],
          weapon_count: 0,
          armor_count: 0,
          potion_count: 0
        )
      end
    end
  end

  describe "#reset_stats" do
    it "is defined" do
      expect(subject).to respond_to(:reset_stats)
    end
    it "resets to default settings" do
      full_character.reset_stats
      expect(full_character).to have_attributes(
        health: 100,
        level: 1,
        attack: 0,
        defense: 00,
        money: 0,
        experience: 0,
        max_hp: 100,
        inventory: {
          current_potions: [],
          current_armor: [],
          current_weapons: []
        }
      )
    end
  end

  describe "#customize_name" do
    it "is defined" do
      expect(subject).to respond_to(:customize_name)
    end
    it "sets name" do
      allow(subject).to receive(:gets).exactly(1).times.and_return('Damian')
      subject.customize_name
      expect(subject.name).to eq('Damian')
    end
  end

  describe "#customize_gender" do
    let(:gender) { {male: 'Male', female: 'Female', other: 'Other'} }
      it "is defined" do
        expect(subject).to respond_to(:customize_gender)
      end
      context "when Male as gender is selected" do
        it 'returns Male' do
          allow(subject).to receive(:gets).and_return('1')
          subject.customize_gender
          expect(subject.gender).to eq('Male')
        end
      end
      context "when Female as gender is selected" do
        it 'returns Female' do
          allow(subject).to receive(:gets).and_return('2')
          subject.customize_gender
          expect(subject.gender).to eq('Female')
        end
      end
      context "when custom gender choice is selected" do
        it 'returns custom gender' do
          allow(subject).to receive(:gets).exactly(2).times.and_return('3', 'Other')
          subject.customize_gender
          expect(subject.gender).to eq('Other')
        end
        it 'defaults to Other when invalid input' do
          allow(subject).to receive(:gets).exactly(2).times.and_return('3', "")
          subject.customize_gender
          expect(subject.gender).to eq('Other')
        end
      end
    context "when unknown choice is selected" do
      it "returns Genderless" do
        allow(subject).to receive(:gets).exactly(1).times.and_return('Genderless')
        subject.customize_gender
        expect(subject.gender).to eq('Genderless')
      end
    end
  end

  describe "#customize_class" do
    it "is defined" do
      expect(subject).to respond_to(:customize_class)
    end
    context "when soldier is selected" do
      it "sets base class to soldier" do
        allow(subject).to receive(:gets).and_return("1")
        subject.customize_class
        expect(subject.base_class).to eq(:soldier)
      end

      let(:soldiers) { %w(Barbarian Knight Paladin Samurai) }
      it "sets main_class to a valid specification of soldier" do
        soldiers.count.times do |choice|
          allow(subject).to receive(:gets).exactly(2).times.and_return("1", choice.next.to_s)
          subject.customize_class
          expect(subject.main_class).to eq(soldiers[choice])
        end
      end
    end
    context "when mage is selected" do
      it "sets base class to mage" do
        allow(subject).to receive(:gets).and_return("2")
        subject.customize_class
        expect(subject.base_class).to eq(:mage)
      end
      let(:mages) { %w(Necromancer Wizard Illusionist Alchemist) }
      it "sets main_class to a valid specification of mage" do
        mages.count.times do |choice|
          allow(subject).to receive(:gets).exactly(2).times.and_return("2", choice.next.to_s)
          subject.customize_class
          expect(subject.main_class).to eq(mages[choice])
        end
      end
    end
    context "when ranged is selected" do
      it "sets base class to ranged" do
        allow(subject).to receive(:gets).and_return("3")
        subject.customize_class
        expect(subject.base_class).to eq(:ranged)
      end
      let(:ranged) { %w(Archer Gunner Tamer Elf) }
      it "sets main_class to a valid specification of ranged" do
        ranged.count.times do |choice|
          allow(subject).to receive(:gets).exactly(2).times.and_return("3", choice.next.to_s)
          subject.customize_class
          expect(subject.main_class).to eq(ranged[choice])
        end
      end
    end
    context "when invalid option is entered" do
      it "defaults to soldier" do
        ["4", "k", "", "hi"].each do |result|
          allow(subject).to receive(:gets).and_return(result)
          subject.customize_class
          expect(subject.base_class).to eq(:soldier)
        end
      end
    end
  end

  describe "#display_game_options_header" do
    it "is defined" do
      expect(subject).to respond_to(:display_game_options_header).with(1).argument
    end
    it "displays a header message" do
      expect(subject).to receive(:puts).and_return a_string_matching(/Game Options/)
      subject.display_game_options_header(1)
    end
  end

  # Goes in the module spec
  describe "#game_options" do
    let(:options) { ["Toggle Battle Scenes", "Change Class", "Change Gender", "Change Name", "Exit"] }
    context "when Toggle Battle Scenes is selected" do
      it "toggles battle scenes" do
        allow(subject).to receive(:choose_array_option).once.with(options, true).and_return(1)
        expect(subject).to receive(:toggle_battle_scenes).once
        subject.game_options
      end
    end
    context "when change class is selected" do
      it "changes class" do
        allow(subject).to receive(:choose_array_option).once.with(options, true).and_return(2)
        expect(subject).to receive(:change_class).once
        subject.game_options
      end
    end
    context "when change gender is selected" do
      it "changes gender" do
        allow(subject).to receive(:choose_array_option).once.with(options, true).and_return(3)
        expect(subject).to receive(:change_gender).once
        subject.game_options
      end
    end
    context "when Change Names is selected" do
      it "changes names" do
        allow(subject).to receive(:choose_array_option).once.with(options, true).and_return(4)
        expect(subject).to receive(:change_name).once
        subject.game_options
      end
    end
    context "when Exit is selected" do
      it "displays message and returns to main menu" do
        allow(subject).to receive(:choose_array_option).once.with(options, true).and_return(5)
        expect(subject).to receive(:display_exiting_game_options).once
        subject.game_options
      end
    end
  end
end


# # Goes in the module spec
# describe "#choose_array_option" do
#   let(:options) { ["Toggle Battle Scenes", "Change Class", "Change Gender", "Change Name", "Exit"] }
#   context "when passed in result_as_num as true" do
#     it "returns valid option from array" do
#       allow(subject).to receive(:gets).and_return("1")
#       subject.choose_array_option(options, true)
#     end
#   end
#   context "when passed in result_as_num as false" do
#     it "returns valid option as num" do
#       allow(subject).to receive(:gets).and_return("1")
#       subject.choose_array_option(options, true)
#     end
#   end
# end

# allow(subject).to receive(:gets).and_return("5")
# subject.choose_array_option(options, true)
# expect(subject).to receive(:puts).and_return a_string_matching(/Exiting/)
