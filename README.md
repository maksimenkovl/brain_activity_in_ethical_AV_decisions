# brain_activity_in_ethical_AV_decisions

This repo contains scripts and results of the brain signals analysis during making ethical decisions regarding the behavior of autonomous vehicle in unavoidable crush situation. Data are relevant to the research article **Video-Based Experiments Better Unveil Societal Biases Towards AI’s Ethical Decisions**.

## Information about the study design and registered data

### Introduction to experimental design.

40 subjects (20 females) took part in two experimental sessions: picture-based and video-based in succession, with a 5-minute break between them. The order of sessions was randomized across subjects so that 20 subjects started with the picture-based scenes, while the remaining 20 subjects started with the video-based scenes.

In the _picture-based scene_, subjects viewed an image depicting pedestrians crossing the road from both sides simultaneously, with an AV approaching. Below the image, they were presented with a pair of virtual car crash outcomes and were asked to indicate their preferred outcome from the two presented options. Subjects were allowed to change their minds as many times as they wanted. Once the subject had made a decision, they were instructed to press the space bar to conclude the scene.

In the _video-based scene_, subjects engaged in an interactive video featuring foreseeable and inevitable crashes. An AV was shown approaching from a distance while two pedestrians crossed the road, one from each side. The AV’s initial position and speed and the pedestrians’ speed and appearance time were randomly determined. Subjects could steer the vehicle to the left or right side using keyboard, allowing them to choose the pedestrian to hit. If no decision was made, the vehicle continued on its course and hit the pedestrian in its lane. Subjects were free to change their minds before hitting any pedestrian. After the collision, subjects pressed the space bar to conclude the scene.

Both picture-based and video-based scenes followed the same protocol. The subject was shown a total of 32 scenes (16 unique scenes, each repeated twice), one after another, in a randomized order with randomly varying gender and age of pedestrians. The order of scenes was randomized for each subject. There was a 2-minute black screen before the onset of the first scene to record the subject's rest-state brain activity. Once the subject finished the scene, it turned into a 4- to 6-second-long black screen before transitioning to the next scene. 

### Information about registration of behavioural metrics

In both picture-based and video-based scenes, we recorded the scene-start time using the photo sensor placed in the upper left corner of the screen. Additionally, we captured keyboard signals, noting the time when subjects pressed the button and recording their choices. Furthermore, we documented information about each scene, including the gender and age of pedestrians on the left and right sides, as well as the initial location of the AV. Response time (RT) was defined as the time elapsed from the scene's start to the moment when the subject pressed the button. 

### Information about brain signals registration

We recorded brain activity signals using multichannel electroencephalography (EEG) with 18 dry EEG sensors (P3, C3, F3, Fz, F4, C4, P4, Cz, Fp1, Fp2, T3, T5, O1, O2, F7, F8, T6, T4) arranged according to the standard 10-10 scheme. The Pz channel served as a common-mode follower. 

## Data processing

### Collecting timings of all scenes

Initially, we utilized photo-sensor signals and captured keyboard signals to record the timestamps of each scene's onset and when the subjects pressed a button. These timestamps are collected for all subjects and scenes and stored in 'TRIGGERS.csv'.

'TRIGGERS.csv' contains 6 columns:

1. **Participant** - unique identifier for the subject
2. **Scene Type** - type of the scene, either Video or Text
3. **Type** - scene condition, for example, pedestrians of the same age but different gender (G), pedestrians of the same gender but different age (A), or pedestrians of different ages and genders (AG). There are also control conditions where age and gender remain the same.
4. **SS Latency** - the moment when this scene starts, measured in samples (300 samples per second) from the start of the EEG recording
5. **BP Latency** - the moment when the subject has pressed the button, measured in samples (300 samples per second) from the start of the EEG recording

### Creating Separate Protocols for All Subjects

To extract brain activity signals associated with processing video-based and picture-based scenes, we need to create protocol files containing timestamps of these intervals and apply them to EEG data. To create these protocol files, we use the script ‘MAKE_PROTOCOLS_TO_EXTRACT_SCENES.ipynb’. This script utilizes data from 'TRIGGERS.csv' to create four output files for each subject. For example, for subject 1, these files are:

1. ‘protocol_1_Text.xlsx’ – This file includes three columns (SS Latency, SS Latency2, Shift), where the first two columns reflect the boundaries of the interval to be extracted. The left boundary corresponds to 4 seconds before the scene onset, and the right boundary is 10 seconds after the scene onset.
2. ‘protocol_1_Video.xlsx’ – This file has the same structure as the text protocol but is applied to the video-based scenes. We use separate files because brain activity is recorded separately for picture-based and video-based scenes.
3. ‘RT_protocol_1_Text.xlsx’ – This file also includes three columns (SS Latency, BP Latency, Type), where the first two columns reflect the scene start and button press times.
4. ‘RT_protocol_1_Video.xlsx’ – This file has the same structure as the RT text protocol but is applied to video-based scenes.

>[!NOTE]   
>The purpose of these protocol files is twofold: ‘protocol_1_Text.xlsx’ is used to extract data from the EEG files (one can find these protocols in the folder [_protocols_](https://github.com/maksimenkovl/brain_activity_in_ethical_AV_decisions/tree/192a72031dcd9d2a03d8ca5abb37a497a490d978/protocols)), while ‘RT_protocol_1_Text.xlsx’ is used for data analysis to account for the response time taken by subjects to respond to each scene (these protocols can be found in the folder _protocols_with_response_time_).


### Processing brain activity data for each subject.

At this step, we use files containing raw EEG data (check folder [_raw_eeg_data_](https://github.com/maksimenkovl/brain_activity_in_ethical_AV_decisions/tree/192a72031dcd9d2a03d8ca5abb37a497a490d978/raw_eeg_data)) along with the generated protocols (check them in folder [_protocols_](https://github.com/maksimenkovl/brain_activity_in_ethical_AV_decisions/tree/192a72031dcd9d2a03d8ca5abb37a497a490d978/protocols)). For instance, for the first subject’s video-based scenes, we utilize ‘1_video_raw.edf’ and ‘protocol_1_Video.xlsx’ as the data file and protocol file, respectively.

Then, we execute the MATLAB file ‘EEG_PREPROCESSING_VIDEO.m’ that performs the following processing steps:

1. References raw EEG signals to the common average.
2. Filters all signals using high-pass (4 Hz) and low-pass (30 Hz) filters.
3. Performs an independent component analysis using the "runica" algorithm to remove eye-blinking artifacts. It requires visual inspection of data.
4. Segments the EEG signals into 16-second trials, time-locked to the scene start, including a 4-second interval before and a 12-second interval after this point.
5. Calculates wavelet power in the frequency band of 4–30 Hz using the Morlet wavelet for each trial.
6. Averages wavelet power across three frequency bands of interest: theta-band (4-8 Hz), alpha-band (8-12 Hz), and beta-band (15-30 Hz).

As a result, the following output files are generated: '1_alpha_Video.mat', '1_theta_Video.mat', and '1_beta_Video.mat' containing time evolution of the wavelet power in three frequency bands at each EEG sensor for each scene. For the picture-based scenes, one should execute MATLAB file ‘EEG_PREPROCESSING_TEXT.m’. The output files can be found in the folder _preprocessed_eeg_data_

>[!NOTE]
>All EEG processing steps are executed using the Fieldtrip toolbox, available for download at https://www.fieldtriptoolbox.org/.
>Processing also requires the updated list of EEG channel names ‘CHANS.mat’.

### Comparing spatial distributions of the wavelet power between picture-based and video-based scenes

To compare the spatial distributions of the wavelet power between picture-based and video-based scenes, we need to average data across the time interval between the scene start and button press. This information is stored in the protocol files, such as ‘RT_protocol_1_Text.xlsx’. The comparison process is three fold:

1. The Python script ‘FORM_SUBJECT-SPECIFIC_ERSP_DATA_VIDEO.ipynb’ reads the preprocessed EEG data of each subject in three frequency bands (‘1_theta_Video.mat’, ‘1_alpha_Video.mat’, and ‘1_beta_Video.mat’) and their corresponding protocols (‘RT_protocol_1_Text.xlsx’). It then aggregates wavelet power over time and all scenes using the median value and combines the data of all subjects together. As a result, it returns three files: ‘ERSP_VIDEO_THETA.csv’, ‘ERSP_VIDEO_ALPHA.csv’, and ‘ERSP_VIDEO_BETA.csv’. Each file is a 2D array representing values of the wavelet power for a particular frequency band for 40 subjects and all EEG sensors.

2. Similarly, the Python script ‘FORM_SUBJECT-SPECIFIC_ERSP_DATA_PICTURE.ipynb’ performs the same operations for the picture-based scenes and returns three files: ‘ERSP_TEXT_THETA.csv’, ‘ERSP_TEXT_ALPHA.csv’, and ‘ERSP_TEXT_BETA.csv’. Each file is a 2D array representing values of the wavelet power for a particular frequency band for 40 subjects and all EEG sensors.

3. Subsequently, the Python script ‘COMPARE_ERSP_DATA_PICTURE_VS_VIDEO.ipynb’ loads the files ‘ERSP_VIDEO_THETA.csv’, ‘ERSP_VIDEO_ALPHA.csv’, and ‘ERSP_VIDEO_BETA.csv’, as well as ‘ERSP_TEXT_THETA.csv’, ‘ERSP_TEXT_ALPHA.csv’, and ‘ERSP_TEXT_BETA.csv’. It performs the comparison of wavelet power between the picture-based and video-based scenes using statistical tests and permutation-based correction for multiple comparisons.

>[!NOTE]
>This analysis requires the MNE toolbox.
>The list of EEG sensor names should be read from file 'EEG_SENSOR_NAMES.xlsx'.

### Comparing temporal evolution of the wavelet power between picture-based and video-based scenes

To compare how the temporal evolution of wavelet power differs between picture-based and video-based scenes, EEG sensors are categorized into four groups based on anatomical regions: frontal, central, occipital+parietal, and temporal. Wavelet power within each region is aggregated using the median value. The resulting waveforms are compared for power between the picture-based and video-based scenes using statistical tests and permutation-based correction for multiple comparisons.

These operations are performed by running the Python script ‘COMPARE_ERSP_WAVEFORMS_PICTURE_VS_VIDEO.ipynb’. It reads the preprocessed EEG data of each subject in three frequency bands ('1_theta_Video.mat', '1_alpha_Video.mat', and '1_beta_Video.mat' for video-based scenes, and '1_theta_Text.mat', '1_alpha_Text.mat', and '1_beta_Text.mat' for picture-based scenes) and their corresponding protocols ('RT_protocol_1_Video.xlsx' and 'RT_protocol_1_Text.xlsx').

>[!NOTE]
>This analysis requires the MNE toolbox.
>The list of EEG sensor names should be read from file 'EEG_SENSOR_NAMES.xlsx'.

### Analysing behavioral responses and their correlation with brain signals

Here, we compare behavioral responses between the video and picture-based scenes and explore correlations between these responses and brain activation.

To conduct the analysis, we run the Python script ‘ANALYSIS_OF_CHOICES_AND_CORRELATION_WITH_ERSP.ipynb’. It reads responses from the file ‘RESPONSES.csv’ and wavelet power data from the files ‘ERSP_VIDEO_THETA.csv’, ‘ERSP_VIDEO_ALPHA.csv’, ‘ERSP_VIDEO_BETA.csv’, ‘ERSP_TEXT_THETA.csv’, ‘ERSP_TEXT_ALPHA.csv’, and ‘ERSP_TEXT_BETA.csv’.


