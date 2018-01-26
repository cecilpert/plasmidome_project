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

# 26 janvier 2018 

## Plan

### 1. Simulation séquences 

- Déterminer la communauté de plasmides/contaminants à utiliser 

- Simulation métagénome à partir des séquences plasmidiques : Grinder (Illumina paired-end metagenome) + FASTQSim PacBio  
Déterminer différentes couvertures à tester. 

- Simulation contamination  
Différents niveaux de contamination 

### 2. Assemblage plasmides 

2 approches : Assemblage puis détection plasmides / nettoyage contamination + assemblage 
 
a. Assemblage 

Assemblage short reads vs assemblage hybride pour voir si ça améliore 

- Assemblage short reads  
Comparer assembleurs "classiques" et assembleurs métagénome ?  
Classique : SPAdes, Abyss (grds jeux de données, de Bruijn), Velvet, SOAPdenovo2, Masurca   
Metagenome : metaSPAdes, Omega, Ray meta, metaVelvet-SL, megaHit  
 
- Assemblage hybride (Illumina + PacBio)  
* hybridSPAdes : construction graphe short-reads puis correction PacBio 
* Cerulean  
* AllPaths-LG : attention, condition strictes taille insertion 
* Masurca (mega-reads algorithm) 
* PBcR : correction long reads par short reads 
* PBJelly
* Unicycler : utilise SPAdes  

b. Détection plasmides 
* plasmidSPAdes : tout peut être fait d'un coup (assemblage hybride + plasmide) 
* Recycler : extraction contigs circulaires 
* PlasFlow : réseaux de neurones, apprentissage basé sur signature génomiques 
* PLACNET : 
* PlasmidFinder : comparaison db. Webtool. Utilise blastn    
Peut-être combiner de novo et approche comparative.  

c. Contamination  
Approche par alignement ?? 

d. Qualité assemblage 
metaQUAST   
