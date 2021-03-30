

Configuration = [
    "Experiment" => "ConfigureYourExperiment.md",
    "Platform" => "PlatformConfiguration.md",       
    "Namelist" => "Namelists.md",
    "Update Namelist" => "UpdateNamelists.md",
    "Model Domain" => "ModelDomain.md",        
    "Vertical Grid" => "VerticalGrid.md",
    "Climate Simulation" => "ClimateSimulation.md",
    "Hires topography" => "How_to_use_hires_topography.md"
]

ECFLOW_TASKS = [
    "Climate" => "ClimateGeneration.md",
    "Observations" => [
        "UseofObservation.md",
        "ObservationOperators.md",
        "ObservationHowto/GNSS.md",
        "ObservationHowto/Amv.md",
        "RadarData.md",
        "Preprocessing" => [
            "ObservationPreprocessing/ObservationData.md", 
            "Bator" => "ObservationPreprocessing/Bator.md", 
            "Oulan" => "ObservationPreprocessing/Oulan.md", 
            "Cope" => "ObservationPreprocessing/Cope.md"
         ]
    ],            
    "Bator" => "ObservationPreprocessing/Bator.md", 
    "Oulan" => "ObservationPreprocessing/Oulan.md",
    "Boundaries" => "BoundaryFilePreparation.md",
    "Screening" => "Screening.md",
    "Surface Analysis" => "Analysis/SurfaceAnalysis.md", 
    "DFI" => "DigitialFilterInitialization.md",
    "Forecast" => "Forecast.md",
    "Post Processing" => [
        "Obsmon" => "PostPP/Obsmon.md", 
        "Diagnostics" => "PostPP/Diagnostics.md", 
        "xtool" => "PostPP/xtool.md", 
        "GL interpolation" => "PostPP/gl/Interpolation.md",
        "Verification" => [
            "PostPP/Verification.md", 
            "PostPP/Extract4verification.md"
        ],
        "Fullpos" => "PostPP/Fullpos.md",
        "FileConversion" => "PostPP/FileConversions.md",
        "gl_grib_api" => "PostPP/gl_grib_api.md",
    ] 
]   

pages = [
    "Home" => "index.md",
    "Running at ECMWF and local" => [
        "Running at ECMWF" => "Harmonie-mSMS.md",
        "Fast start on cca" => "Fast_start_on_cca.md",
        "Quick start local" => "QuickStartLocal.md",
    ],  
    "Installation" => [
        "Installation" => "Installation.md",
        "General Software Requirements" => "General.md",
        "Makeup" => "Build_with_makeup.md",
        "Stand Alone ODB" => "StandaloneOdb.md",
        "Redhat7" => "Redhat7Install.md",
        "Centos6" => "Centos6Install.md"    
    ],  
    "The Harmonie Script" => "TheHarmonieScript.md",
    "Profiling and Traceback" => "DrHook.md",
    "File Formats" => "FileFormats.md",     
    "Job Scheduling" => [           
        "ECFlow" => "ECFLOW.md",
        "mXCdp" => "scripts/mXCdp.md", 
        "mSMS" => "scripts/mSMS.md"
    ],
    "Testbed and Mitraillette" => [
        "Testbed" => "Evaluation/HarmonieTestbed.md",
        "Mitraillette" => "Evaluation/Mitraillette.md"
    ],
    "Directories  and Binaries" => [
        "Directories" => "Content.md", 
        "Binaries" => "Binaries.md"
    ],
    "Configuration" => Configuration,                
    "ECFlow tasks" => ECFLOW_TASKS, 
    "Other" => [        
        "Scalability_and_Refactoring.md",
        "HarmonieBenchMark.md",
        "MFaccess.md",
        "Phasing.md" 
    ]
]
