# brain_activity_in_ethical_AV_decisions

This repo contains scripts and results of the brain signals analysis during making ethical decisions regarding the behavior of autonomous vehicle in unavoidable crush situation. Data are relevant to the research article **Video-Based Experiments Better Unveil Societal Biases Towards AI’s Ethical Decisions**.

## Information about the study design and registered data

### Introduction to experimental design.

40 subjects (20 females) took part in two experimental sessions: picture-based and video-based in succession, with a 5-minute break between them. The order of sessions was randomized across subjects so that 20 subjects started with the picture-based scenes, while the remaining 20 subjects started with the video-based scenes.

In the _picture-based scene_, subjects viewed an image depicting pedestrians crossing the road from both sides simultaneously, with an AV approaching. Below the image, they were presented with a pair of virtual car crash outcomes and were asked to indicate their preferred outcome from the two presented options. Subjects were allowed to change their minds as many times as they wanted. Once the subject had made a decision, they were instructed to press the space bar to conclude the scene.

In the _video-based scene_, subjects engaged in an interactive video featuring foreseeable and inevitable crashes. An AV was shown approaching from a distance while two pedestrians crossed the road, one from each side. The AV’s initial position and speed and the pedestrians’ speed and appearance time were randomly determined. Subjects could steer the vehicle to the left or right side using the keys "1" and "2" on the keyboard, allowing them to choose the pedestrian to hit. If no decision was made, the vehicle continued on its course and hit the pedestrian in its lane. Subjects were free to change their minds before hitting any pedestrian. After the collision, subjects pressed the space bar to conclude the scene.

Both picture-based and video-based scenes followed the same protocol. The subject was shown a total of 32 scenes (16 unique scenes, each repeated twice), one after another, in a randomized order with randomly varying gender and age of pedestrians. The order of scenes was randomized for each subject. There was a 2-minute black screen before the onset of the first scene to record the subject's rest-state brain activity. Once the subject finished the scene, it turned into a 4- to 6-second-long black screen before transitioning to the next scene. 

### Information about registration of behavioural metrics

In both picture-based and video-based scenes, we recorded the scene-start time using the photo sensor placed in the upper left corner of the screen. Additionally, we captured keyboard signals, noting the time when subjects pressed the button and recording their choices. Furthermore, we documented information about each scene, including the gender and age of pedestrians on the left and right sides, as well as the initial location of the AV. Response time (RT) was defined as the time elapsed from the scene's start to the moment when the subject pressed the button. 

### Information about brain signals registration

We recorded brain activity signals using multichannel electroencephalography (EEG) with 18 dry EEG sensors (P3, C3, F3, Fz, F4, C4, P4, Cz, Fp1, Fp2, T3, T5, O1, O2, F7, F8, T6, T4) arranged according to the standard 10-10 scheme. The Pz channel served as a common-mode follower. 

## Data processing

### Collecting timings of all scenes

Initially, we utilized photo-sensor signals and captured keyboard signals to record the timestamps of each scene's onset and when the subjects pressed a button. These timestamps are collected for all subjects and scenes and stored in 'TRIGGERS.csv'.

'TRIGGERS.csv' contains 6 columns:

-Participant_ - unique identifier for the subject
*Scene Type_ - type of the scene, either Video or Text
+Type_ - scene condition, for example, pedestrians of the same age but different gender (G), pedestrians of the same gender but different age (A), or pedestrians of different ages and genders (AG). There are also control conditions where age and gender remain the same.
_SS Latency_ - the moment when this scene starts, measured in samples (300 samples per second) from the start of the EEG recording
_BP Latency_ - the moment when the subject has pressed the button, measured in samples (300 samples per second) from the start of the EEG recording

### Creating Separate Protocols for All Subjects

To extract brain activity signals associated with processing video-based and picture-based scenes, we need to create protocol files containing timestamps of these intervals and apply them to EEG data. To create these protocol files, we use the script ‘MAKE_PROTOCOLS_TO_EXTRACT_SCENES.ipynb’. This script utilizes data from 'TRIGGERS.csv' to create four output files for each subject. For example, for subject 1, these files are:

‘protocol_1_Text.xlsx’ – This file includes three columns (SS Latency, SS Latency2, Shift), where the first two columns reflect the boundaries of the interval to be extracted. The left boundary corresponds to 4 seconds before the scene onset, and the right boundary is 10 seconds after the scene onset.
‘protocol_1_Video.xlsx’ – This file has the same structure as the text protocol but is applied to the video-based scenes. We use separate files because brain activity is recorded separately for picture-based and video-based scenes.
‘RT_protocol_1_Text.xlsx’ – This file also includes three columns (SS Latency, BP Latency, Type), where the first two columns reflect the scene start and button press times.
‘RT_protocol_1_Video.xlsx’ – This file has the same structure as the RT text protocol but is applied to video-based scenes.
The purpose of these protocol files is twofold: ‘protocol_1_Text.xlsx’ is used to extract data from the EEG files, while ‘RT_protocol_1_Text.xlsx’ is used for data analysis to account for the response time taken by subjects to respond to each scene.



