# Livelayer-Software
A Semi-Automatic Software for Segmentation of Layers and Objects in Optical Coherence Tomography Images 

* Department of Electrical and Computer Engineering, Isfahan University of Technology.
* MISP Research Center, Isfahan University of Medical Sciences.


### USAGE

Open app1.mlapp file in the MATLAB App Designer environment.

#### ---- File Tab ----

We've put three formats that are most commonly used so that the user can select the desired one and load it into the MATLAB software environment. After loading data with one of the “.mat”, “.octbin” or ".bin" formats, the user has an overview of different B-Scans using the top spinner. The "Rotate" button is set to rotate the image by 90, 180 or 270 degrees. Additionally, there is a text box in which the user types an appropriate path to save all layers and fluids’ coordinates and information.


#### ---- Manual Layer Segmentation Tab ----

The user can entirely acquire a boundary manually by pushing the mouse and dragging it over the boundary. Every time the user's hand is picked up, a question dialogue appears on the figure and asks whether the user wants to continue or not. As long as the answer is yes, multiple parts of the boundary are obtained and once the answer turns to no, these parts are joined together and smoothed to make an entity for each selected boundary.

#### ---- Auto Layer Segmentation Tab ----

This block displays two possibilities for semi-automatic segmentation of retinal layers and only a few clicks are needed.

In the Semi-Automatic Tab, the user chooses his desired B-Scan as well as the boundary to-be-detected on the left hand side of the app window. Then, a MATLAB figure opens up waiting for a click on the first pixel of the opted boundary. After clicking on the initial pixel of the desired path, as the user moves the mouse along the path, the smallest cost path based on the brightness of pixels is displayed.He should drag the mouse on the path so as to discover a route which best fits that path and click on whenever he observes that the route has become inappropriate. This process proceeds until the entire path is acquired. The user should press the enter key at this time to close the figure. To facilitate moving between boundaries by the user, we have made colored lamps demonstrating the state of each boundary. Whereas the green color indicates that the boundary is acquired completely, yellow and red colors are signs of partially and not acquired boundaries, respectively.

In the Manual-Grid Tab, the user chooses the to-be-segmented boundary and enters the number of adequate vertical lines by which that boundary should be gridded. After that, a gridded B-Scan opens up in a figure in order for the user to click the boundary exactly on the plotted vertical lines. When finished, the interpolated boundary is depicted.

In the Layer Correction Tab, the user can correct the defective boundaries in previous two methods. The user should first, click on the beginning and end of the intended path for correction. This path is omitted and gridded by vertical lines the number of which should be set by the “Grid” textbox. The following steps is exactly like the Manual-Grid layer segmentation. When finished, the corrected boundary is replaced.

In the Save Layer Info Tab, all information related to the app’s semi-automatic section is saved.


#### ---- Fluid Segmentation Tab ----

The user enters the desired B-Scan number and then, selects the fluid type he would like to find from the three types shown 
in the left hand side (IRF, SRF, PED). Therefore, the program enters an infinite loop and receives as many objects as the user wants and the text box value indicating the “Number of Objects” is added automatically when each object is taken. If the user finds an object incorrectly and prefers to delete it, he can click on the “Delete” button and obtain the deleted object again. After detecting all planned fluids, by clicking on the “Finish” button, all fluid coordinates and their mask images could be stored in a MATLAB structure.

In the Semi-Automatic Tab, the user should follow the same procedure in the Semi-Automatic Tab of the Auto Layer Segmentation Tab for each fluid.

In the Manual Tab, fluids are acquired manually and every time the user pushes the mouse and drags it over the fluid’s boundary and picks his hand up, one separate fluid is recognized.

#### ---- Peripapillary Tab ----

First of all, the user should load a relevant data of the optic nerve head. A proper data with a ".png" format is put here for a real test. Following that, the user should adopt a procedure similar to that of the B-Scans' segmentation to acquire all peripapillary-related layers. 
