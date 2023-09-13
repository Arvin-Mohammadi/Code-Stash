import pygame 
import numpy as np 
import random 


# constants 
IMAGE_WIDTH = 640
IMAGE_HEIGHT = 480
BIRD_SIZE = 20
window_size = (IMAGE_WIDTH, IMAGE_HEIGHT)
GRAVITY = 4
JUMP = 11
GAME_SPEED = 3
ROCKETSHIP_PATH = 'space_ship.png'
PIPES_PATH = 'pipes.png'

# colors 
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)


# game class 
class FlappyBirdAI: 
    def __init__(self, window_size):

        self.screen = pygame.display.set_mode(window_size)
        self.clock = pygame.time.Clock()
        self.highscore = 0 
        self.rocket_image = pygame.image.load(ROCKETSHIP_PATH)
        self.pipe_image = pygame.image.load(PIPES_PATH)
        self.reset()

    def reset(self): 
        
        self.game_over = 0 
        self.score = 0
        
        self.rect = pygame.Rect(IMAGE_WIDTH/4 - BIRD_SIZE, IMAGE_HEIGHT/4 - BIRD_SIZE, BIRD_SIZE, BIRD_SIZE)
        self.bird = self.flappy_bird(self.rect)
        self.pipes = [] # 2d array, each sample has (left, top)


    def flappy_bird(self, rect):

        self.bird = pygame.draw.rect(self.screen, BLACK, rect)
        self.screen.blit(self.rocket_image, (rect.right - 20, rect.bottom - 20))
        pygame.display.update()

        self.bird_position = (self.rect.top, self.rect.bottom, self.rect.left, self.rect.right)

        return self.bird_position


    def position_update(self, key_pressed):

        previous_position = self.rect

        if key_pressed: 
            self.rect = pygame.Rect(self.rect.left, self.rect.top + GRAVITY - JUMP, self.rect.width, self.rect.height)
        else:
            self.rect = pygame.Rect(self.rect.left, self.rect.top + GRAVITY, self.rect.width, self.rect.height)
        
        if (self.rect.top < 0) or (self.rect.bottom > 480):
            self.game_over = 1
            self.rect = previous_position

        return self.rect
        

    def get_key(self):

        key_pressed = 0
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()

            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_SPACE:
                    key_pressed = 1

        return key_pressed

    def create_pipe(self):

        new_pipe = [640, random.randint(6, 23)*20] # bottom pipe (haha bottom) (left, top)

        self.pipes.append(new_pipe)


    def is_collided(self, bird_position):

        for pipe in self.pipes:
            if pipe[0] < 160 and pipe[0] > 120:
                if (self.bird_position[0] > pipe[1]) or (self.bird_position[1] < pipe[1] - 120):
                    self.game_over = 1
            elif (pipe[0] < 120) and (pipe[0] > 120 - GAME_SPEED):
                print("The score is: ", self.score + 1)
                self.score += 1 


        return self.game_over 


    def pipe_move(self):

        # move every pipe forward 
        if self.pipes != []:
            for idx, pipe in enumerate(self.pipes): 
                # print(self.pipes[idx])
                self.pipes[idx][0] -= GAME_SPEED

                if self.pipes[idx][0] < -20:
                    self.pipes.pop(0)



    def pipe_draw(self):


        self.screen.fill(BLACK)
        for pipe in self.pipes:
            pipe_rect = pygame.Rect(pipe[0], pipe[1], 20, 480-pipe[1])
            pygame.draw.rect(self.screen, WHITE, pipe_rect)
            pipe_rect = pygame.Rect(pipe[0], 0, 20, pipe[1] - 120)
            pygame.draw.rect(self.screen, WHITE, pipe_rect)

            for block in range(int(pipe[1]/20), 23):
                self.screen.blit(self.pipe_image, (pipe[0], block*20))

            for block in range(1, int((pipe[1] - 120)/20)):
                self.screen.blit(self.pipe_image, (pipe[0], block*20))

    def get_state(self):

        state = [self.bird_position[0], 0]

        for pipe in self.pipes:
            if pipe[0] < self.bird_position[3] + 60:
                state = [self.bird_position[0], pipe[1]]

        return state

    def ai_reward(self, previous_score):

        if self.game_over or self.is_collided(self.bird_position): reward = -1
        elif self.score > previous_score: reward = 1 
        else: reward= 0 

        done  = self.game_over or self.is_collided(self.bird_position)
        score =  self.score

        return reward, done, score 


# main loop 
if __name__ == "__main__":

    pygame.init()

    # init game class 
    game = FlappyBirdAI(window_size)
    

    jumping_period = 0
    key_pressed = 0
    pipe_cooldown = 1

    # game loop
    while True: 

        pygame.time.delay(10)


        # jump 
        if key_pressed and (jumping_period <= 10): 
            key_pressed = 1
            jumping_period += 1
        else: 
            key_pressed = game.get_key() 
            jumping_period = 0


        # updating the bird position 
        rect = game.position_update(key_pressed)
        game.flappy_bird(rect) 

        # checking if game is over
        if game.game_over or game.is_collided(game.bird_position):
            if game.highscore < game.score:
                game.highscore = game.score
                print("Yay! new highscore")
            game.reset()
        

        # create pipes randomly 
        if pipe_cooldown == 1:
            pipe_cooldown = 70
            game.create_pipe()
        else: 
            pipe_cooldown -= 1

        # move pipes forward
        game.pipe_move()
        game.pipe_draw()


# TODO: output state of the game - [h, b1, b2, ... b96]