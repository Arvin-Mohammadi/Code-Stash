# Make WorkSpace In ROS
Here I'll write down the repetitive steps of making a new workspace and the configuration for ROS 

credits: @ArticulatedRobotics on youtube

## 1. Creating A Workspace

for making a new workspace run this code on terminal (you should be in the home directory) 
```
  mkdir -p my_workspace/src
  cd my_workspace
  colcon build --symlink-install
```

## 2. Creating A Package 
making a new package in the source directory 
```
  cd src 
  ros2 pkg create --build-type ament_cmake my_package
```

inside the directory: `/my_workspace/src/my_package` make the new directory of `launch`
inside that directory make two files. 

1. file number #1: `talker.launch.py`

```
  from launch import LaunchDescription
  from launch_ros.actions import Node
  
  def generate_launch_description():
    return LaunchDescription([
      Node(
        package="demo_nodes_cpp", 
        executable="talker"
      )
    ])
```

2. file number #2: `listener.launch.py`

```
  from launch import LaunchDescription
  from launch_ros.actions import Node
  
  def generate_launch_description():
    return LaunchDescription([
      Node(
        package="demo_nodes_cpp", 
        executable="listener"
      )
    ])
```

next update `CMakeLists.txt` (add the launch directory)

```
install(DIRECTORY launch
 DESTINATION share/${PROJECT_NAME}
)
```
and update `package.xml`:

```
  <exec_depend>demo_nodes_cpp</exec_depend>
  <exec_depend>demo_nodes_py</exec_depend>
```
build the package (from the top level from src):

```
  cd ..
  colcon build --symlink-install
```
## 3. Test The Package

now we have to tell terminal where to find our package: (we do this in the directory ~/my_workspace

```
  source install/setup.bash
```

then we launch the talker file and listener fle:

```
  ros2 launch my_package talker.launch.py
```

# Transform Systems (TF) 

There are two types of transforms: 
- static transforms: doens't update
- dynamic transforms: updates in real time 

For transforms, because we don't use the topics directly, instead of "publishing and subscribing" we call it "Broadcasting Listening" 

## 1. Broadcasting Static Transforms 

Run the following command to broadcast a static tf: (rotations are in radians)

```
  ros2 run tf2_ros static_transform_publisher x y z yaw pitch roll parent_frame child_frame 
```

and example of the code above can be seen in the following command: 

![example transform](https://i.postimg.cc/FsHg0Dgr/example-transform.png)

run this in terminal number 1 
```
  ros2 run tf2_ros static_transform_publisher 2 1 0 0.785 0 0 world robot_1
```

run this in terminal number 2 
```
  ros2 run tf2_ros static_transform_publisher 1 0 0 0 0 0 robot_1 robot_2
```

to check this via ros' visualization tool run the following command in terminal number 3
```
  ros2 run rviz2 rviz2
```

or for short:
```
  rviz2
```
## 2. Broadcasting Dynamic Transforms 

first thing is that we need a couple of installation if you don't already have them

```
  sudo apt install ros-foxy-xacro ros-foxy-joint-state-publisher-gui
```

download the [URDF File](https://github.com/ArthasMenethil-A/Tips-and-Tricks-of-python/blob/main/ROS-Env-Setup/assets/example_robot.urdf.xacro)

run this command in terminal number 1:

```
  ros2 run robot_state_publisher robot_state_publisher --ros-args -p robot_description:="$( xacro ~/example_robot.urdf.xacro )" 
```

run this command in terminal number 2: 

```
  ros2 run joint_state_publisher_gui joint_state_publisher_gui 
```

This will open up a GUI with sliders

## 3. Debugging Transforms 

use the following command while your transforms are running: 

```
  ros2 run tf2_tools view_frames.py
```

# URDF Files 

This part is dedicated to making a URDF part from solidworks and import it to ROS. Each URDF file is made up of "Links" and "Joints". 

The most common types of joints are: 

![common types of joints](https://i.postimg.cc/nckQKh8b/common-joint-tpyes.png)

an example of URDF file: Head over to [Example number 2](https://github.com/ArthasMenethil-A/Programming-Tricks/blob/main/ROS-Env-Setup/assets/example2_robot.urdf.xacro) file and run these commands: 


```
  ros2 run robot_state_publisher robot_state_publisher --ros-args -p robot_description:="$( xacro ~/example2_robot.urdf.xacro )" 

```

run this command in the 2nd terminal:

```
  ros2 run joint_state_publisher_gui joint_state_publisher_gui 
```

run this command in the 3rd terminal:

```
  rviz2
```

# MAKE A URDF FILE FROM SOLIDWORKS 

credits: [@Age.of.Robotics](https://www.youtube.com/playlist?list=PLeEzO_sX5H6TBD6EMGgV-qdhzxPY19m12)

## Step 1. Robot Design 

Create the parts of the robot 

## Step 2. Assembly

Assemble the Robot parts in solid assembly

(make sure to put the robot in a starting position that is desired to have as default) 

## Step 3. Coordinate System and Axes

Create a Global Coordinate system 
Create Axis for each of the links 

## Step 4. Install Solidworks-To-URDF Plug-in 

go to [this link](http://wiki.ros.org/sw_urdf_exporter)
install the plug-in, restart your solidworks. check that it is enables by clicking on the little arrow beside "options" and taking a look at add-ins

## Step 5. Export To URDF 
Now we're ready to export the files. how do we do that? 

go to menu Tools>Export to URDF

Then fill in the information and finalize the export

## IMPORT URDF FILE IN ROS

For a more complete version of doing this you can go to [this link](https://github.com/kunalaglave4/import_your_custom_urdf_package_to_ROS/blob/b9541ef0dae257ff35e2c30349717af0b41de66e/Importing_URDF_Package_from_Soloidworks_in_ROS.pdf)













