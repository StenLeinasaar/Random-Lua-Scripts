-- Blackjack Game (Text-Based)

local F= require 'F'

-- Constants
local CARD_WIDTH = 100
local CARD_HEIGHT = 140

-- Variables
local deck = {}
suits = {"hearts", "spade", "club", "diamond"}
local playerHand = {}
local dealerHand = {}
local playerScore = 0
local dealerScore = 0
local gameState = "deal"  -- Possible states: deal, player, dealer, end

Card = {suit = nil, value = nil}

function Card:new (o, suit, value)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.suit = suit or nil
    self.value = value or nil
    return o
end

function createDeck()
    for i=1, 4 do
        print(i)
        for j = 2, 13 do
            card = Card:new(nil,suits[i], j)
            print(F'Card is {card.value} of {card.suit}')
        end
    end
end

-- Shuffle the deck
function shuffleDeck()
    deck = {}
    for i = 1, 52 do
        table.insert(deck, i)
    end
    for i = 52, 2, -1 do
        local j = love.math.random(i)
        deck[i], deck[j] = deck[j], deck[i]
    end
end

-- Deal a card


createDeck()


