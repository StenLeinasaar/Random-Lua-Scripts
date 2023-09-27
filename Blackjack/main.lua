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
    for i = 1, #deck do
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
end


function dealerMove(hand)
    while handValue(hand) <= 16 do
        hit(hand)
    end
end

-- function to check the handvalue of the player
-- MUST ADD, if player previously had an ACE, then if score is going over 21, take the previous ace to be 1
function handValue(hand)
    val = 0
    for i=1, #hand do
        -- when card is higher value than 10, not including 10
        if hand[i].value > 10 then
            -- if card is ace
            if hand[i].value == 14 then
                -- if it will break the score, the ace takes on value 1 instead.
                if (val + hand[i].value) > 21 then
                    val = val + 1
                -- else it will be 11
                else
                    val = val + 11
                end
            -- else it was the other picture card
            else
                val =  val + 10
            end
        else
            val = val + hand[i].value
        end
    end
    -- if it is 14 then the prompt a choice for a user
    return val
end


-- Check winner and see if someone is over.
function checkWinner(dealer, player)

    -- First check if one or both are 21
    if dealer == 21 then
        if player == 21 then
            return "tie"
        else
            return "dealer"
        end
    elseif player == 21 then
        -- Here we already know that dealer is not 21
        return "player"
    elseif player > 21 then
        if dealer > 21 then
            -- both are bust
            return "tie"
        else
            -- Dealer won
            return "dealer"
        end
    elseif dealer > 21 then
        return "player"
    -- This is where we need to check for values and who has higher value
    else
        if dealer < player then
            return "player"
        elseif player < dealer then
            return "dealer"
        else
            return "tie"
        end 
    end
end



-- Main driver function to play the game
function play()
    while true do
        dealCards()
        -- show player their own hand
        printHand(playerHand)

        -- While player wants a new card or until they are bust
        while true do


            io.write("Do you want another card? {yes/no}")
            answer = io.read()


            if answer == "yes" then
                hit(playerHand)
                if handValue(playerHand) > 21 then
                    print("YOU ARE BUST")
                    break
                end
                -- Later here I can add that it draws out the new card
                print("Your new hand is:")
                printHand(playerHand)
            else
                break
            end
        end


        -- Call dealer moves
        dealerMove(dealerHand)
        print("Dealer hand was")
        printHand(dealerHand)
        break
    end

    game_end()
end


function game_end()
    if checkWinner(handValue(dealerHand), handValue(playerHand)) == "player" then
        print("Player won")
    elseif checkWinner(handValue(dealerHand), handValue(playerHand)) then
        print("Dealer wins")
    else
        print("nobody won. It is a tie")
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

-- Function to print out the hand of any player
function printHand(hand)
    print("Cards are:")
    for i=1, #hand do
        print(F"{hand[i].value} \t of \t {hand[i].suit}")
    end
    print(F"Value of the hand: \t {handValue(hand)}")
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