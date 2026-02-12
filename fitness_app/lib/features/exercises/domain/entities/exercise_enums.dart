enum MuscleGroup {
  chest,
  back,
  shoulders,
  biceps,
  triceps,
  legs,
  abs,
  cardio,
  fullBody,
  other;

  String get displayName {
    switch (this) {
      case MuscleGroup.chest:
        return 'Peito';
      case MuscleGroup.back:
        return 'Costas';
      case MuscleGroup.shoulders:
        return 'Ombros';
      case MuscleGroup.biceps:
        return 'Bíceps';
      case MuscleGroup.triceps:
        return 'Tríceps';
      case MuscleGroup.legs:
        return 'Pernas';
      case MuscleGroup.abs:
        return 'Abdominais';
      case MuscleGroup.cardio:
        return 'Cardio';
      case MuscleGroup.fullBody:
        return 'Full Body';
      case MuscleGroup.other:
        return 'Outros';
    }
  }
}

enum Equipment {
  barbell,
  dumbbell,
  machine,
  cable,
  kettlebell,
  bodyWeight,
  elasticBand,
  other;

  String get displayName {
    switch (this) {
      case Equipment.barbell:
        return 'Barra';
      case Equipment.dumbbell:
        return 'Halteres';
      case Equipment.machine:
        return 'Máquina';
      case Equipment.cable:
        return 'Polia';
      case Equipment.kettlebell:
        return 'Kettlebell';
      case Equipment.bodyWeight:
        return 'Peso Corporal';
      case Equipment.elasticBand:
        return 'Elástico';
      case Equipment.other:
        return 'Outro';
    }
  }
}

extension MuscleGroupExtension on MuscleGroup {
  String get imagePath {
    switch (this) {
      case MuscleGroup.chest:
        return 'assets/images/chest.webp';
      case MuscleGroup.back:
        return 'assets/images/back.webp';
      case MuscleGroup.shoulders:
        return 'assets/images/shoulders.webp';
      case MuscleGroup.biceps:
        return 'assets/images/biceps.webp';
      case MuscleGroup.triceps:
        return 'assets/images/triceps.webp';
      case MuscleGroup.legs:
        return 'assets/images/legs.webp';
      case MuscleGroup.abs:
        return 'assets/images/abs.webp';
      case MuscleGroup.cardio:
        return 'assets/images/cardio.webp';
      case MuscleGroup.fullBody:
        return 'assets/images/fullbody.webp';
      case MuscleGroup.other:
        return 'assets/images/other.webp';
    }
  }
}