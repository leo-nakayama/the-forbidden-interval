# ============================================================
# THE FORBIDDEN INTERVAL
# Sonic Pi Generative Composition
# Version 1.0
#
# C Dorian -> F# Locrian
# Augmented Fourth Transition (+6 semitones)
# Perfect Fifth Resolution (+7 semitones)
# ============================================================

use_bpm 60

# ------------------------------------------------------------
# 1. CONFIGURATION
# ------------------------------------------------------------

dorian_root = 60

transition_probability = 0.05
resolution_probability = 0.15

min_dorian_events = 5
min_locrian_events = 3

note_density = 0.35

rest_min = 3
rest_max = 12

base_amp = 0.5

# ------------------------------------------------------------
# 2. SCALE GENERATOR
# ------------------------------------------------------------

dorian_scale = [
  0, 2, 3, 5, 7, 9, 10
].map { |n| dorian_root + n }

locrian_root = dorian_root + 6

locrian_scale = [
  0, 1, 3, 5, 6, 8, 10
].map { |n| locrian_root + n }

# Special transition and resolution notes

augmented_fourth = locrian_root
perfect_fifth = locrian_root + 7

# ------------------------------------------------------------
# 3. STATE MANAGER
# ------------------------------------------------------------

state = :dorian

dorian_events = 0
locrian_events = 0

# ------------------------------------------------------------
# 4. SOUND ENGINE
# ------------------------------------------------------------

with_fx :reverb,
  room: 0.9,
mix: 0.45 do
  
  # ----------------------------------------------------------
  # 5. GENERATIVE SEQUENCER
  # ----------------------------------------------------------
  
  loop do
    
    if state == :dorian
      
      # ------------------------------------------------------
      # DORIAN STATE
      # ------------------------------------------------------
      
      if rand < note_density
        
        note = choose(dorian_scale)
        
        use_synth :pretty_bell
        
        play note,
          amp: base_amp,
          release: 3,
          pan: rrand(-0.15, 0.15)
        
        dorian_events += 1
        
      end
      
      # Transition condition
      
      if dorian_events >= min_dorian_events &&
          rand < transition_probability
        
        # Augmented fourth transition event
        
        use_synth :pretty_bell
        
        play augmented_fourth,
          amp: base_amp * 0.8,
          release: 5,
          pan: 0
        
        state = :locrian
        locrian_events = 0
        
        sleep 2
        
      else
        
        sleep rrand(rest_min, rest_max)
        
      end
      
    elsif state == :locrian
      
      # ------------------------------------------------------
      # LOCRIAN STATE
      # ------------------------------------------------------
      
      if rand < note_density
        
        note = choose(locrian_scale)
        
        use_synth :pretty_bell
        
        play note,
          amp: base_amp * 0.85,
          release: 4,
          pan: rrand(-0.25, 0.25)
        
        locrian_events += 1
        
      end
      
      # Resolution condition
      
      if locrian_events >= min_locrian_events &&
          rand < resolution_probability
        
        # Perfect fifth resolution event
        
        use_synth :pretty_bell
        
        play perfect_fifth,
          amp: base_amp,
          release: 5,
          pan: 0
        
        state = :dorian
        dorian_events = 0
        
        sleep 3
        
      else
        
        sleep rrand(rest_min, rest_max)
        
      end
      
    end
    
  end
  
end
