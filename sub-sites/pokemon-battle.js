var playerOne;
var opponent;
initialize();

function Player(theName, theClassify) {
	this.name = theName;
	this.classify = theClassify;
	this.pokeParty = [];
	this.currentPoke = this.pokeParty[0];
}

function Pokemon(theName) {
	this.name = jsUcFirst(theName);
	this.classify = theName;
	this.activeHP = 100;
	this.stats;
	this.moveSet;
	this.ability;
}

function useMove(player, moveNum) {
	document.getElementById('text-area').innerHTML =  player.currentPoke.name + " used move" + moveNum + "!";
	
}

function addPokeToParty(player, pokeName) {
	player.pokeParty.push(new Pokemon(pokeName));
	if(player.currentPoke == undefined) {
		player.currentPoke = player.pokeParty[0].name;
	}
}

function initialize() {
	playerOne = new Player('Player', 'player');
	document.getElementById('text-area').innerHTML = playerOne.name;
	opponent = new Player('Brandon', 'opponent');
	addPokeToParty(playerOne, "venusaur");
	addPokeToParty(playerOne, "charizard");
	addPokeToParty(playerOne, "blastoise");
	addPokeToParty(playerOne, "snorlax");
	addPokeToParty(playerOne, "mew");
	addPokeToParty(playerOne, "mewtwo");
	addPokeToParty(opponent, "galvantula");	
	addPokeToParty(opponent, "infernape");	
	addPokeToParty(opponent, "klinklang");	
	addPokeToParty(opponent, "wishiwashi");	
	addPokeToParty(opponent, "sylveon");
	addPokeToParty(opponent, "medicham-mega");		
	document.getElementById('text-area').innerHTML = 'Time to battle!';
	document.getElementById('player-poke').src = "https://play.pokemonshowdown.com/sprites/xyani-back/" + playerOne.currentPoke.classify + ".gif";
	document.getElementById('opponent-poke').src = "https://play.pokemonshowdown.com/sprites/xyani/" + opponent.currentPoke.classify + ".gif";
	document.getElementById('player-status-bar').innerHTML = playerOne.currentPoke.name;
	document.getElementById('opponent-status-bar').innerHTML = opponent.currentPoke.name;
	switchPoke(playerOne, 1);
	switchPoke(opponent, 1);
	switchPoke(playerOne, 2);
	switchPoke(opponent, 2);
	switchPoke(playerOne, 3);
	switchPoke(opponent, 3);
	switchPoke(playerOne, 4);
	switchPoke(opponent, 4);
	switchPoke(playerOne, 5);
	switchPoke(opponent, 5);
}

function switchPoke(player, pokeNum) {
	playerName = player.name;
	player.currentPoke = player.pokeParty[pokeNum];
	//document.getElementById('text-area').innerHTML = 'CurrentPoke changed...';
	document.getElementById(player.classify + '-status-bar').innerHTML = jsUcFirst(player.currentPoke.name);
	if(player.classify == 'player') {
		document.getElementById(player.classify + '-poke').src = "https://play.pokemonshowdown.com/sprites/xyani-back/" + player.currentPoke.classify + ".gif";
	}
	else if (player.classify == 'opponent') {
		document.getElementById(player.classify + '-poke').src = "https://play.pokemonshowdown.com/sprites/xyani/" + player.currentPoke.classify + ".gif";
	}
}


function jsUcFirst(string) 
{
    return string.charAt(0).toUpperCase() + string.slice(1);
}

const sleep = (milliseconds) => {
  return new Promise(resolve => setTimeout(resolve, milliseconds))
}
