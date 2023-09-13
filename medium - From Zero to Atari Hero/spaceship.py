import pygame 
import numpy as np 
import random 


# constants 
IMAGE_WIDTH = 640
IMAGE_HEIGHT = 480
BLOCK_SIZE = 40
window_size = (IMAGE_WIDTH, IMAGE_HEIGHT)
ROCKETSHIP_PATH = 'space_ship.png'
PIPES_PATH = 'obstacle.png'

# colors 
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)


class SpaceShipAI: 

    def __init__(self, window_size):
        
        self.screen = pygame.display.set_mode(window_size)
        self.highscore = 0 
        self.rocket_img = pygame.image.load(ROCKETSHIP_PATH)
        self.rocket_img = pygame.transform.scale(self.rocket_img, (40, 40))
        self.obstacle_img = pygame.image.load(PIPES_PATH)
        self.obstacle_img = pygame.transform.scale(self.obstacle_img, (40, 40))
        self.reset()


    def reset(self):
        self.obstacles = [] # 2d Array position of each obstacle (x, y)
        self.game_over = 0 
        self.score = 0 
        self.start_jump = 0 

        self.player_rect = pygame.Rect(IMAGE_WIDTH/4 - BLOCK_SIZE, IMAGE_HEIGHT/2, BLOCK_SIZE, BLOCK_SIZE)
        # self.player = pygame.draw.rect(self.screen, WHITE, self.player_rect)
        self.screen.blit(self.rocket_img, (self.player_rect.x, self.player_rect.y))
        pygame.display.update()


    def play_step(self, key_pressed=None, previous_score=None):

        self.screen.fill(BLACK)

        if key_pressed == None: key_pressed = self._get_key()

        if key_pressed == 0:
            pass
        elif key_pressed == 1: 
            self.player_rect.update(self.player_rect.left, self.player_rect.top - BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)
        elif key_pressed == 2:
            self.player_rect.update(self.player_rect.left, self.player_rect.top + BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE)


        self.screen.blit(self.rocket_img, (self.player_rect.x, self.player_rect.y))

        # obstacles
        self._obstacles()

        # final touches 
        pygame.display.update()


        if self.is_collided():
            pass  
            # if self.score > self.highscore:
            #     self.highscore = self.score
            #     print("new highscore", self.highscore)
            # self.reset()
        else: 
            self.score += 1
            # print("score:", self.score)

        # calculating the outputs 
        done = self.is_collided()

        score = self.score

        reward = 0 
        if self.score % 50 == 0:
            reward = 1
        if self.score > self.highscore:
            reward = 10
        if done:
            reward = -10

        return reward, score, done


    def is_collided(self):

        # check collision with walls
        if self.player_rect.y<0 or self.player_rect.y>440:
            self.game_over = 1

        # check collision with obstacles
        if self.obstacles:
            for obstacle in self.obstacles: 
                if  (obstacle[0]==self.player_rect.x or obstacle[0]==self.player_rect.x - 40)  and obstacle[1]==self.player_rect.y:
                    self.game_over = 1 
        
        return self.game_over


    def _get_key(self):

        key_pressed = 0
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()

            if event.type == pygame.KEYDOWN:

                if event.key == pygame.K_UP:
                    key_pressed = 1
                if event.key == pygame.K_DOWN:
                    key_pressed = 2

        return key_pressed

    def _obstacles(self):


        # move all obstacles forward 
        if self.obstacles:
            for idx, obstacle in enumerate(self.obstacles):
                self.obstacles[idx]  = [int(self.obstacles[idx][0]) - 40, int(self.obstacles[idx][1])]
                # print(self.obstacles[idx]) # = [obstacle[0] - 40, obstacle[1]]
                temp_rect = pygame.Rect(obstacle[0], obstacle[1], BLOCK_SIZE, BLOCK_SIZE)
                self.screen.blit(self.obstacle_img, (temp_rect.x, temp_rect.y))
        
        # create new obstacle 
        if random.randint(0, 2) == 0:

            new_obstacle = [640, random.randint(0, 11)*40]
            self.obstacles.append(new_obstacle)

        # destroy gone obstacles 
        if self.obstacles:
            for obstacle in self.obstacles.copy():
                if obstacle[0] < 0:
                    self.obstacles.remove(obstacle)




def game_loop():

    pygame.init()

    game = SpaceShipAI(window_size)

    while True:
        pygame.time.delay(100)

        game.play_step()




if __name__ == "__main__":

    game_loop()