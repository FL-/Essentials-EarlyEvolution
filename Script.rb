#===============================================================================
# * Early Evolution - by FL (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. It makes certain pokémon who evolve
# per level may evolve in an early level (like Kling evolve to Klang at level 23
# instead of level 38). You can limit this script to only works when a certain
# item is on the bag.
#
#== INSTALLATION ===============================================================
#
# To this script works, put it above main OR convert into a plugin. Add into
# PBS\items.txt:
#
#  [EVOLUTIONCHARM]
#  Name = Evolution Charm
#  NamePlural = Evolution Charms
#  Pocket = 8
#  Price = 0
#  Flags = KeyItem
#  Description = A charm that reduces the evolution level of Pokémon that evolve in high levels.
#
# Or make ITEM constant being nil to make this script always active.
#
#== HOW TO USE =================================================================
#
# Edit NEW_LEVEL_PER_EVOLUTION to set the evolution levels.
#
#== NOTES ======================================================================
#
# This script works with other Level methods variants, like LevelFemale. Just
# add the pokémon on NEW_LEVEL_PER_EVOLUTION.
#
# This script affect all pokémon forms, so setting level 20 for Dugtrio also
# affects its Alolan form evolution level.
#
# At debug menu, in Other Options, you can select "Print Early Evolutions" to
# generate a txt with all pokémon evolve levels, including the ones inside of 
# NEW_LEVEL_PER_EVOLUTION, so you can copy/paste values of new included species.
#
#===============================================================================

if !PluginManager.installed?("Early Evolution")
  PluginManager.register({                                                 
    :name    => "Early Evolution",                                        
    :version => "1.0.1",                                                     
    :link    => "https://www.pokecommunity.com/showthread.php?t=477104",             
    :credits => "FL"
  })
end

module EarlyEvolution
  # Edit this hash to change levels. 
  # Removing lines just make the pokémon evolve at default level.
  NEW_LEVEL_PER_EVOLUTION = {
    :RAPIDASH     => 35, # 40
    :SLOWBRO      => 32, # 37
    :MUK          => 33, # 38
    :WEEZING      => 30, # 35
    :RHYDON       => 32, # 42
    :OMASTAR      => 35, # 40
    :KABUTOPS     => 35, # 40
    :DRAGONITE    => 50, # 55

    :MAGCARGO     => 33, # 38
    :PILOSWINE    => 28, # 33
    :JYNX         => 25, # 30
    :ELECTABUZZ   => 25, # 30
    :MAGMAR       => 25, # 30
    :TYRANITAR    => 50, # 55
    
    :LAIRON       => 22, # 32
    :AGGRON       => 37, # 42
    :MEDICHAM     => 32, # 37
    :WAILORD      => 35, # 40
    :VIBRAVA      => 25, # 35
    :FLYGON       => 40, # 45
    :ALTARIA      => 30, # 35
    :CLAYDOL      => 31, # 36
    :CRADILY      => 35, # 40
    :ARMALDO      => 35, # 40
    :BANETTE      => 32, # 37
    :DUSCLOPS     => 32, # 37
    :GLALIE       => 37, # 42
    :SEALEO       => 22, # 32
    :WALREIN      => 39, # 44
    
    :PURUGLY      => 33, # 38
    :DRAPION      => 35, # 40
    :TOXICROAK    => 32, # 37
    :ABOMASNOW    => 35, # 40

    :KROKOROK     => 24, # 29
    :DARMANITAN   => 30, # 35
    :CARRACOSTA   => 32, # 37
    :ARCHEOPS     => 32, # 37
    :GARBODOR     => 31, # 36
    :GOTHORITA    => 22, # 32
    :GOTHITELLE   => 36, # 41
    :DUOSION      => 22, # 32
    :REUNICLUS    => 36, # 41
    :SWANNA       => 30, # 35
    :VANILLISH    => 25, # 35
    :VANILLUXE    => 37, # 47
    :AMOONGUSS    => 34, # 39
    :JELLICENT    => 35, # 40
    :GALVANTULA   => 31, # 36
    :FERROTHORN   => 35, # 40
    :KLANG        => 23, # 38
    :KLINKLANG    => 39, # 49
    :EELEKTRIK    => 24, # 39
    :BEHEEYEM     => 32, # 42
    :LAMPENT      => 26, # 41
    :FRAXURE      => 23, # 38
    :HAXORUS      => 38, # 48
    :BEARTIC      => 32, # 37
    :MIENSHAO     => 35, # 50
    :GOLURK       => 33, # 43
    :BISHARP      => 37, # 52
    :BRAVIARY     => 39, # 54
    :MANDIBUZZ    => 39, # 54
    :ZWEILOUS     => 35, # 50
    :HYDREIGON    => 49, # 64
    :VOLCARONA    => 44, # 59

    :PYROAR       => 30, # 35
    :DOUBLADE     => 25, # 35
    :BARBARACLE   => 34, # 39
    :DRAGALGE     => 33, # 48
    :CLAWITZER    => 32, # 37
    :TYRANTRUM    => 34, # 39
    :AURORUS      => 34, # 39
    :SLIGGOO      => 30, # 40
    :AVALUGG      => 32, # 37
    :NOIVERN      => 33, # 48

    :TOXAPEX      => 33, # 38
    :PALOSSAND    => 32, # 42
    :HAKAMOO      => 30, # 35

    :SANDACONDA   => 31, # 36
    :HATTREM      => 22, # 32
    :HATTERENE    => 37, # 42
    :MORGREM      => 22, # 32
    :GRIMMSNARL   => 37, # 42
    :DRAKLOAK     => 35, # 50
    :DRAGAPULT    => 50, # 60
    :MRRIME       => 37, # 42
	
    :ESPATHRA     => 30, # 35
    :PALAFIN      => 33, # 38
    :REVAVROOM    => 35, # 40
    :ARCTIBAX     => 30, # 35
    :BAXCALIBUR   => 49, # 54
  }

  # Item. When nil, work without item.
  ITEM = :EVOLUTIONCHARM  

  # txt file path for print methods. To specific directories, use "\". 
  # Only works if directory path already exists.
  TXT_FILE_PATH = "EarlyEvolutionPrint"

  # Used on print method
  EVOLUTION_LEVEL_METHODS = [
    :Level, :LevelMale, :LevelFemale, :LevelDay, :LevelNight, :LevelMorning,
    :LevelAfternoon, :LevelEvening, :LevelNoWeather, :LevelSun, :LevelRain,
    :LevelSnow, :LevelSandstorm, :LevelCycling, :LevelSurfing, :LevelDiving,
    :LevelDarkness, :LevelDarkInParty, :AttackGreater, :AtkDefEqual, 
    :DefenseGreater, :Silcoon, :Cascoon, :Ninjask, :Shedinja
  ]

  def self.file_full_path
    return TXT_FILE_PATH + ".txt"
  end

  def self.evolution_level(new_species, parameter, check_item=true)
    return parameter if check_item && ITEM && !$bag.has?(ITEM)
    return NEW_LEVEL_PER_EVOLUTION.fetch(new_species, parameter)
  end

  def self.print_levels_on_txt
    File.open(file_full_path, "w"){|file| file.write(
      "# Created at "+Time.now.strftime("%Y-%m-%d %H:%M:%S")+"\n\n"+
      generate_all_levels_string
    )}
  end

  def self.generate_all_levels_string
    ret = "  NEW_LEVEL_PER_EVOLUTION = {"
    already_printed_evolutions = []
    GameData::Species.each do |species|
      for evo_data in species.get_evolutions
        next if already_printed_evolutions.include?(evo_data[0])
        evo_string = evolution_string(evo_data[0],evo_data[1],evo_data[2])
        next if !evo_string
        ret += evo_string
        already_printed_evolutions.push(evo_data[0])
      end
    end
    ret += "\n  }"
    return ret
  end

  def self.evolution_string(evolution, method, parameter)
    return nil if !EVOLUTION_LEVEL_METHODS.include?(method)
    adjusted_parameter = evolution_level(
      evolution,parameter, false
    ).to_s.ljust(2)
    evo_const = evolution.to_s.ljust(12)
    return "\n    :#{evo_const} => #{adjusted_parameter}, # #{parameter}"
  end
end

MenuHandlers.add(:debug_menu, :print_early_evolution, {
  "name"        => _INTL("Print Early Evolutions"),
  "parent"      => :other_menu,
  "description" => _INTL(
    "Print all level evolution of existing pokémon in a txt."
  ),
  "effect"      => proc {
    msgwindow = pbCreateMessageWindow
    if safeExists?(EarlyEvolution.file_full_path) && !pbConfirmMessageSerious(
      _INTL("{1} already exists. Overwrite it?", EarlyEvolution.file_full_path)
    )
      pbDisposeMessageWindow(msgwindow)
      next
    end
    pbMessageDisplay(msgwindow,_INTL("Please wait.\\wtnp[0]"))
    EarlyEvolution.print_levels_on_txt
    pbMessageDisplay(msgwindow,
      _INTL("File generated in {1}.", EarlyEvolution.file_full_path)
    )
    pbDisposeMessageWindow(msgwindow)
  }
})

class Pokemon
  def check_evolution_on_level_up
    return check_evolution_internal { |pkmn, new_species, method, parameter|
      parameter = EarlyEvolution.evolution_level(new_species, parameter)
      success = GameData::Evolution.get(method).call_level_up(pkmn, parameter)
      next (success) ? new_species : nil
    }
  end
end