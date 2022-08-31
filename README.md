# Roblox Spells Template
This is a very basic template and description of its functions

Firstly, this template is **not** perfect and definitely can be improved.

# Class layout

So, every spells should be a class with the basic variables :
Player  (Player)
Cooldown/IsInUse (boolean)
Remote (RemoteEvent)

next, Each new spell is in the corresponding folder for its Race, because;
LocalScript creates new and initializes spells according to the player character's "Race" attribute
same goes for a ServerScript, which adds listeners from those spells to the server
both the destruction and disconnection of the class and listeners are handled by just these two scripts.
Note, that every character needs to have a "Race" attribute set in order for their spells to load.

# functions

**Spell.new(player) : SpellObj**
this function creates a new object of the spell, must provide a player

**Spell:Init()**
Initializes the core function of the spell, fires the remote, sets cd/InUse to true and calls self:DoSpell(self.Target)
(Initializes as in, for the example, connects to the UserInput, etc..)

**Spell:DoSpell(...)**
Is what happens after the server has been fired to

**Spell:Destroy()**
Simply destroys the object, disconnects all connections and (hopefully) readies it for garbage collection

**ConnectListeren(Event, spell, callback) : RBXConnection**
Connects a listener on server to the remote event given, if fired, checks if spell equals this listener's, if yesm then calls callback. Returns the connection which must be disconnected if it's not in use!

**SpellServer(player,target,isActive)**
The server logic, that is later connected to the listener

**Spell.InitServer(Event) : RBXConnection**
The initialization on the server, connects SpellServer function by the listener and returns that connection


## End
That would be all, if you have any questions or suggestions, don't be afraid to contact me.
Preferably through my discord (Wizzy#8225)



