import os
import re
import sys
import shutil
import platform
from pathlib import Path

# Usually my linux system changes, darwin remains same
if platform.system() == "Linux":
    posts_dir = str(Path("~/Projects/blog.kanishkk.me/content/posts/").expanduser())
    attachments_dir = str(Path("~/kanishkvault/attachments/").expanduser())
    static_images_dir = str(Path("~/Projects/blog.kanishkk.me/static/images/").expanduser())
elif platform.system() == "Darwin":
    # Paths
    posts_dir = "/Users/kanishkpachauri/Documents/kanishkblog/content/posts/"
    attachments_dir = "/Users/kanishkpachauri/kanishkvault/attachments/"
    static_images_dir = "/Users/kanishkpachauri/Documents/kanishkblog/static/images/"
else:
    print("Unsupported operating system. Exiting.")
    sys.exit(1)
# Step 1: Process each markdown file in the posts directory
for filename in os.listdir(posts_dir):
    if filename.endswith(".md"):
        filepath = os.path.join(posts_dir, filename)
        
        with open(filepath, "r") as file:
            content = file.read()
        
        # Step 2: Find all image links in the format ![Image Description](/images/Pasted%20image%20...%20.png)
        images = re.findall(r'\[\[([^]]*\.png)\]\]', content)
        
        # Step 3: Replace image links and ensure URLs are correctly formatted
        for image in images:
            # Prepare the Markdown-compatible link with %20 replacing spaces
            markdown_image = f"![Image Description](/images/{image.replace(' ', '%20')})"
            content = content.replace(f"[[{image}]]", markdown_image)
            
            # Step 4: Copy the image to the Hugo static/images directory if it exists
            image_source = os.path.join(attachments_dir, image)
            if os.path.exists(image_source):
                shutil.copy(image_source, static_images_dir)

        # Step 5: Write the updated content back to the markdown file
        with open(filepath, "w") as file:
            file.write(content)

print("Markdown files processed and images copied successfully.")

