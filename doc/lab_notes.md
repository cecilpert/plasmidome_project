# 24/01/2018

Présentation Genevieve Didier

Première idée : simulation données Illumina + Pacbio plasmides bactériens pour tester logiciels d'assemblage plasmidome. 
Simulation pour différentes couvertures, % PacBio, simulation contamination

**Liste logiciels**  
- plasmidSPAdes
- PLACNET

**Détection plasmides** 
- PlasmidFinder : utilise bdd  
- Recycler 
- Co-abundance gene groups (CAGs) approach (*voir Nielsen 2014, Identification and assembly of genomes and genetic elements in complex metagenomic samples without using reference genomes*)
- Plasmid Profiler  
- PlasFlow

**Assemblage metagenome** 
- MetaSPAdes 
- Omega  
- MegaHit

Publi comparaison : https://doi.org/10.1371/journal.pone.0169662

**Assemblage short + long reads**
- HybridSPAdes

**Biblio** 
Beaucoup de publis utilisent approches de type Blast pour identifier les plasmides.  

**Stratégies?** 

1. Simulation données  

2. Assemblage 
- short read classique : spades

Assemblage sur données brutes puis détection plasmides ?  
- Test   
Eliminer contamination ?

# 25 janvier 2018

- Installation Mendeley

**Simulation séquences** 
- Grinder : Illumina PE metagenome  
- FASTQsim : PacBio metagenome (Illumina mais SE)
- Communauté plasmides ??  

1. Pas de contamination, couvertures différentes Illumina et PacBio (combien pour séquençage classique?). 
2. Ajout de contamination, différents niveaux.  

**Détection plasmides**  
- PlasFlow : réseaux de neurones  
- plasmidSPAdes 
- cBar : pentamer frequencies, SMO based model   
- Recycler 
-  

**Hybrid assembly**
- SPAdes   
- MaSuRCA 
- Cerulean 
- PbCR : correction des longs reads avec short reads 
- PBJelly : gap filling 
- Abyss : scaffolding with long sequences
- HGAP : correction long reads avec lui-même 
- ALLPATH-LG  


  
