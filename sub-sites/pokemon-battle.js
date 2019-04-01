var playerOne;
var opponent;
var playerArray;

function Player(theName, theClassify) {
	this.name = theName;
	this.classify = theClassify;
	this.pokeParty = [];
	this.currentPoke;
}

function Pokemon(theName) {
	this.name = jsUcFirst(theName);
	this.classify = theName;
	this.activeHP = 100;
	this.stats;
	this.moveSet;
	this.ability;
}

function useMove(playerNum, moveNum) {
	document.getElementById('text-area').innerHTML = playerArray[playerNum].currentPoke.name + " used Move " + (moveNum+1) + "!";
}

function addPokeToParty(player, pokeName) {
	player.pokeParty.push(new Pokemon(pokeName));
	if(player.pokeParty.length == 1) {
		player.currentPoke = player.pokeParty[0];
	}
}

function initialize() {
	playerOne = new Player('Player', 'player');
	opponent = new Player('Brandon', 'opponent');
	playerArray = [playerOne, opponent];
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
	document.getElementById('battle-area').style.visibility = "visible";
	document.getElementById('text-area').style.visibility = "visible";
	document.getElementById('button-row').style.visibility = "visible";
	document.getElementById('start-button').style.visibility = "hidden";
}

function switchPoke(player, pokeNum) {
	playerName = player.name;
	player.currentPoke = player.pokeParty[pokeNum];
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
