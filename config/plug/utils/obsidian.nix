{ lib, ... }:
{
  plugins.obsidian = {
    enable = lib.mkDefault true;
    settings = {
      completion = {
        min_chars = 2;
        nvim_cmp = true;
      };
      # A list of workspace names, paths, and configuration overrides
      #If you use the Obsidian app, the 'path' of a workspace should generally being
      # your vault root (where the `.obsidian` folder is located).of
      # When obsidian.nvim is loaded by your plugin manager, it will automatically settings
      # the workspace to the first workspace in the list whose `path` is a parent of then
      #current markdown file being edited.
      workspaces = [
        {
          name = "Notes";
          path = "/mnt/media/vaults/notes";
        }
      ];
      # -- Optional, if you keep notes in a specific subdirectory of your vault.
      # Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings thisway
      # way then set 'mappings = {}'.

      mappings = {
        # Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        gf = {
          action = "require('obsidian').util.gf_passthrough";
          opts = {
            noremap = false;
            expr = true;
            buffer = true;
          };
        };
        # Toggle check-boxes.
        "<leader>ch" = {
          action = "require('obsidian').util.toggle_checkbox";
          opts.buffer = true;
        };
      };

      # Optional, customize how note IDs are generated given an optional title.
      # @param title string|?note_id_func
      # @return string
      note_id_func = ''
        function(title)
          -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
          -- In this case a note with the title 'My new note' will be given an ID that looks
          -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
          local suffix = ""
          if title ~= nil then
            -- If title is given, transform it into valid file name.
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            -- If title is nil, just add 4 random uppercase letters to the suffix.
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          return tostring(os.time()) .. "-" .. suffix
        end
      '';
      # Optional, customize how note file names are generated given the ID, target directory, and title.
      note_path_func = ''
        function(spec)
          -- This is equivalent to the default behavior.
          local path = spec.dir / tostring(spec.id)
          return path:with_suffix(".md")
        end
      '';

      wiki_link_func = ''
        function(opts)
          return require('obsidian.util').wiki_link_id_prefix(opts)
        end
      '';

      markdown_link_func = ''
        function(opts)
          return require('obsidian.util').markdown_link(opts)
        end
      '';

    };
  };
}
