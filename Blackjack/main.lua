-- Blackjack Game (Text-Based)

local F= require 'F'
local math = require 'math'

-- Constants
local CARD_WIDTH = 100
local CARD_HEIGHT = 140

-- Variables
local deck = {}

local playerHand = {}
local dealerHand = {}
local playerScore = 0
local dealerScore = 0
local gameState = "deal"  -- Possible states: deal, player, dealer, end

local Card = {}

function Card:new(suit, value)
    local o = {
        suit = suit,
        value = value
    }
    setmetatable(o, self)
    return o
end

function createDeck()
    suits = {"hearts", "spade", "club", "diamond"}
    for i=1, 4 do
        for j = 2, 14 do
            card = Card:new(suits[i], j)
            -- print(F'Card is {card.value} of {card.suit}')
            table.insert(deck, card)
        end
    end
end

function printDeck()
    length = #deck
    for i = 1, length do
        -- print(F"{deck[i].value} of {deck[i].suit}")
    end
end

-- Shuffle the deck
function shuffleDeck(value)
    while value > 0 do
        for i = 52, 2, -1 do
            local j = math.random(i)
            deck[i], deck[j] = deck[j], deck[i]
        end
        value = value - 1
    end
end

-- Deal a card

function dealCards()
    shuffleDeck(6)
    table.insert(playerHand, table.remove(deck, 1))
    table.insert(dealerHand, table.remove(deck, 1))
    table.insert(playerHand, table.remove(deck, 1))
    table.insert(dealerHand, table.remove(deck, 1))
end

function hit(hand)
    table.insert(hand, table.remove(deck, 1))
    print("added a card to a hand")
end


-- function to check the handvalue of the player
function handValue(hand)
    val = 0
    -- in blackjack. Number is a number. so until 10 it is the value
    -- use De Morgan's Law
    for i=1, 2 do
        -- when card is higher value than 10, not including 10
        if hand[i].value > 10 then
            -- if card is ace
            if hand[i].value == 14 then
                -- print("card is a ace")
                -- if it will break the score, the ace takes on value 1 instead.
                if (val + hand[i].value) > 21 then
                    -- print("Ace will break it, adding it to be 1 instead")
                    val = val + 1
                    -- print(F"New value is {val}")
                -- else it will be 11
                else
                    val = val + 11
                    -- print(F"New value is {val}")
                end
            -- else it was the other picture card
            else
                -- print("Card is a picture")
                val =  val + 10
                -- print(F"New value is {val}")
            end
        else
            -- print("it was a random number card")
            val = val + hand[i].value
            -- print(F"New value is {val}")
        end
    end

    -- if it is above 10 but not 14, then it is 10. 

    -- if it is 14 then the prompt a choice for a user
    return val
end

function checkWinner(dealer, player)
    if dealer < player then
        return "player"
    elseif player < dealer then
        return "dealer"
    else
        return "tie"
    end
end


function printHand(hand)
    print("Cards are:")
    for i=1, #hand do
        print(F"{hand[i].value} \t of \t {hand[i].suit}")
    end
    print(F"Value of the hand: \t {handValue(hand)}")
end


function play()
    while true do
        dealCards()
        -- local dealer = handValue(dealerHand)
        -- local player = handValue(playerHand)

        -- print(F"player has {#playerHand} cards")
        -- print(F"The player card is {playerHand[1].value} of suit {playerHand[1].suit}")
        -- print(F"The player card is {playerHand[2].value} of suit {playerHand[2].suit}")

        -- print(F"{player}")

        -- print("########################")

        -- print(F"The dealer hand is {dealerHand[1].value} of suit {dealerHand[1].suit}")
        -- print(F"The dea;er hand is {dealerHand[2].value} of suit {dealerHand[2].suit}")

        -- print(F"{dealer}")

        printHand(playerHand)
        printHand(dealerHand)

        if checkWinner(handValue(dealerHand), handValue(playerHand)) == "player" then
            print("Player won")
            break
        elseif checkWinner(handValue(dealerHand), handValue(playerHand)) then
            print("Dealer wins")
            break
        else
            print("nobody won. It is a tie")
            break

        end
    end



    -- ##### The end of the game section  ---> Possibly put it into its own function.

    io.write("Do you want to play again? (yes/no)?")
    answer = io.read()
    if answer == "yes" then
        reset()
        play()
    else
        print("Nice playing with you")
    end
end


function initilize()
    createDeck()
    play()
end

function reset()

    -- remove player cards
    for i = 1, #playerHand do
        table.insert(deck, table.remove(playerHand,1))
    end

    -- remove dealer cards
    for i = 1, #dealerHand do
        table.insert(deck, table.remove(dealerHand,1))
    end

end

initilize()


-- dealCards()

-- print(F"And length of a deck is {#deck}")