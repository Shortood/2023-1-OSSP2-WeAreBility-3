# Generated by Django 4.2.1 on 2023-05-11 11:32

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = []

    operations = [
        migrations.CreateModel(
            name="Users",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                ("user_index", models.IntegerField(max_length=9999)),
                ("userid", models.CharField(max_length=50)),
                ("title", models.CharField(max_length=50)),
                ("createdDateTime", models.CharField(max_length=50)),
                ("introduction", models.CharField(max_length=999)),
                ("coursekeyword", models.CharField(max_length=300)),
                ("segmentId", models.IntegerField(max_length=100)),
                ("startPoint", models.TextField(max_length=100)),
                ("endPoint", models.TextField(max_length=100)),
                ("points", models.TextField(max_length=9999)),
            ],
        ),
    ]
